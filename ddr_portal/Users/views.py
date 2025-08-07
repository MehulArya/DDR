# your_app/views.py

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from .forms import CustomUserCreationForm, CustomLoginForm
from django.contrib.auth.decorators import login_required
from django.db import connection
from .models import Folder, Document, Upload
from django.http import HttpResponse
from openpyxl import Workbook
from openpyxl.styles import Font
import json
from .models import Document
from django.contrib.auth.decorators import login_required
from .models import Upload
import hashlib
from django.urls import reverse
from django.contrib import messages
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from .models import UserRole
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
#
@login_required
def download_excel(request, doc_id):
    document = get_object_or_404(Document, id=doc_id)
    raw_data = document.dynamic_data

    try:
        # Clean newline characters
        if isinstance(raw_data, str):
            raw_data = raw_data.replace('\n', '').replace('\r', '').strip()
        else:
            return HttpResponse("dynamic_data is not a string", status=400)

        # Parse JSON
        dynamic_data = json.loads(raw_data)

        # Get main key and columns
        first_key = next(iter(dynamic_data))
        columns = dynamic_data[first_key]["columns"]

        # Create Excel
        wb = Workbook()
        ws = wb.active
        ws.title = document.title
        ws.sheet_properties.tabColor = "1072BA"
        ws.freeze_panes = "A2"

        for index, col in enumerate(columns, start=1):
            name = col.get("name", "Unnamed")
            cell = ws.cell(row=1, column=index, value=name)
            cell.font = Font(bold=True)
            ws.column_dimensions[cell.column_letter].width = max(len(name) + 2, 20)

        # Prepare response
        response = HttpResponse(
            content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        )
        filename = f"{document.title.replace(' ', '_')}.xlsx"
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        wb.save(response)
        return response

    except json.JSONDecodeError as je:
        print("JSON Decode Error:", je)
        return HttpResponse(f"JSON Decode Error: {je}", status=400)

    except KeyError as ke:
        print(" Missing expected key:", ke)
        return HttpResponse(f"Missing expected key: {ke}", status=400)

    except Exception as e:
        print(" Unexpected Error:", e)
        return HttpResponse(f"Unexpected Error: {e}", status=400)



@login_required
def profile_view(request):
    user = request.user

    try:
        user_role = UserRole.objects.select_related('role').get(user=user)
        role_name = user_role.role.role_name
    except UserRole.DoesNotExist:
        role_name = 'Not Assigned'

    return render(request, 'profile.html', {
        'name': user.get_full_name() or user.username,
        'email': user.email,
        'phone': 'Not Available',  # or customize if needed
        'role': role_name,
    })




def home_view(request):
    return render(request, 'home.html')

@login_required
def see_template(request, doc_id):
    document = get_object_or_404(Document, id=doc_id)
    raw_data = document.dynamic_data

    try:
        if isinstance(raw_data, str):
            raw_data = raw_data.replace('\n', '').replace('\r', '').strip()
        else:
            return HttpResponse("❌ dynamic_data is not a string", status=400)

        dynamic_data = json.loads(raw_data)
        first_key = next(iter(dynamic_data))
        columns = dynamic_data[first_key]["columns"]

        return render(request, 'template_preview.html', {
            'document': document,
            'columns': columns
        })

    except json.JSONDecodeError as je:
        return HttpResponse(f"JSON Decode Error: {je}", status=400)
    except KeyError as ke:
        return HttpResponse(f"Missing key: {ke}", status=400)
    except Exception as e:
        return HttpResponse(f"Unexpected error: {e}", status=400)


#this is for uplolad part

@login_required
def upload_folder_list(request):
    folders = Folder.objects.all()
    return render(request, 'upload_file_list.html', {'folders': folders})

@login_required
def upload_document_list(request, folder_id):
    folder = get_object_or_404(Folder, id=folder_id)
    documents = Document.objects.filter(folder_id=folder.id)
    return render(request, 'upload_document_list.html', {
        'folder': folder,
        'documents': documents
    })


@require_POST
@login_required
def ajax_upload_file(request):
    try:
        uploaded_file = request.FILES.get('file')
        folder_id = request.POST.get('folder_id')
        document_id = request.POST.get('document_id')

        if not uploaded_file or not folder_id or not document_id:
            return JsonResponse({'success': False, 'error': 'Missing data'})

        folder = get_object_or_404(Folder, id=folder_id)
        document = get_object_or_404(Document, id=document_id)
        file_blob = uploaded_file.read()

        Upload.objects.create(
            document=document,
            folder=folder,
            uploaded_by=request.user,
            file_name=uploaded_file.name,
            file_blob=file_blob,
            file_size=uploaded_file.size,
            mime_type=uploaded_file.content_type,
            sha256_hash=hashlib.sha256(file_blob).hexdigest()
        )

        return JsonResponse({'success': True})

    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)})



