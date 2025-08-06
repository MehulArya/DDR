# your_app/views.py

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from .forms import CustomUserCreationForm, CustomLoginForm
from django.contrib.auth.decorators import login_required
from django.db import connection
from .models import Folder, Document
from django.http import HttpResponse
from openpyxl import Workbook
from openpyxl.styles import Font
from django.shortcuts import get_object_or_404
import json
from .models import Document
from django.contrib.auth.decorators import login_required
from .models import Upload

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
    return render(request, 'profile.html')

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


from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from .models import Folder, Document, Upload
from django.contrib import messages
from django.http import HttpResponseRedirect
from django.urls import reverse
import hashlib

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

@login_required
def upload_file(request, folder_id, document_id):
    folder = get_object_or_404(Folder, id=folder_id)
    document = get_object_or_404(Document, id=document_id)

    if request.method == 'POST' and request.FILES.get('file'):
        uploaded_file = request.FILES['file']
        file_blob = uploaded_file.read()
        file_name = uploaded_file.name
        file_size = uploaded_file.size
        mime_type = uploaded_file.content_type
        sha256_hash = hashlib.sha256(file_blob).hexdigest()

        Upload.objects.create(
            document=document,
            folder=folder,
            uploaded_by=request.user,
            file_name=file_name,
            file_blob=file_blob,
            file_size=file_size,
            mime_type=mime_type,
            sha256_hash=sha256_hash
        )

        messages.success(request, 'File uploaded successfully!')
        return HttpResponseRedirect(reverse('upload_document_list', args=[folder.id]))

    return render(request, 'upload_form.html', {
        'folder': folder,
        'document': document
    })
