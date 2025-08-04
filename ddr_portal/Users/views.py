# your_app/views.py

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from .forms import CustomUserCreationForm, CustomLoginForm
from django.contrib.auth.decorators import login_required
from django.db import connection
from .models import Folder, Document
import openpyxl
from openpyxl.styles import Font
from django.http import HttpResponse
import json


# -----------------------------
# Auth-related views
# -----------------------------

def signup_view(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('role_redirect')
    else:
        form = CustomUserCreationForm()
    return render(request, 'signup.html', {'form': form})


def login_view(request):
    if request.method == 'POST':
        form = CustomLoginForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('/role_redirect')
    else:
        form = CustomLoginForm()
    return render(request, 'login.html', {'form': form})


def logout_view(request):
    logout(request)
    return redirect('login')


# -----------------------------
# Role-based dashboards
# -----------------------------

@login_required
def admin_view(request):
    return render(request, 'admin.html')


@login_required
def head_view(request):
    return render(request, 'head.html')


@login_required
def faculty_view(request):
    return render(request, 'faculty.html')


@login_required
def role_redirect(request):
    user_id = request.user.id
    with connection.cursor() as cursor:
        cursor.execute("SELECT role_id FROM USER_ROLES WHERE user_id = %s", [user_id])
        row = cursor.fetchone()

    if row:
        role_id = row[0]
        if role_id == 1:
            return redirect('admin')
        elif role_id == 2:
            return redirect('head')
        elif role_id == 3:
            return redirect('faculty')

    return redirect('login')


# -----------------------------
# Folder and document views
# -----------------------------

@login_required
def folder_list(request):
    folders = Folder.objects.filter(is_active=True)
    return render(request, 'folder_list.html', {'folders': folders})


@login_required
def folder_documents(request, folder_id):
    folder = get_object_or_404(Folder, id=folder_id)
    documents = Document.objects.filter(folder_id=folder.id)
    return render(request, 'documents.html', {
        'folder': folder,
        'documents': documents
    })


# -----------------------------
# Excel file download view
# -----------------------------

@login_required
def download_excel(request, document_id):
    document = get_object_or_404(Document, id=document_id)

    try:
        data = json.loads(document.dynamic_data)
        root_key = next(iter(data))
        columns = data[root_key]['columns']
    except (json.JSONDecodeError, KeyError, TypeError):
        return HttpResponse("Invalid JSON format in dynamic_data", status=400)

    # Create Excel
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = document.title

    # Add column names as header
    header_font = Font(bold=True)
    for col_idx, col in enumerate(columns, 1):
        cell = ws.cell(row=1, column=col_idx, value=col['name'])
        cell.font = header_font

    # Generate response
    response = HttpResponse(
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    response['Content-Disposition'] = f'attachment; filename="{document.title}.xlsx"'
    wb.save(response)

    return response
