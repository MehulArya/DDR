# your_app/views.py

from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, authenticate, logout
from .forms import CustomUserCreationForm, CustomLoginForm
from django.contrib.auth.decorators import login_required
from django.db import connection
from .models import Folder, Document, Upload,FolderUserRole
from django.http import HttpResponse
from openpyxl import Workbook
from openpyxl.styles import Font
import json
from django.http import HttpResponseForbidden
from .models import Document
from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from .models import Folder, Role, FolderUserRole
from django.contrib import messages
from django.utils.timezone import now
from django.shortcuts import render
from .utils import get_user_role_id
from .models import Upload
import hashlib
from django.urls import reverse
from django.contrib import messages
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from .models import UserRole, ActivityLog
from django.utils import timezone
from .models import Folder, Document



from django.shortcuts import render, get_object_or_404, redirect
from django.utils import timezone
from django.contrib import messages
from .models import Folder, Document




from django.utils.timezone import now
from django.db.models import Q
from django.contrib import messages
from django.shortcuts import render, redirect, get_object_or_404
from django.utils.timezone import now
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from .models import Folder, Document, Role, FolderUserRole


from django.shortcuts import render, get_object_or_404
from .models import Folder, Document



from .models import FolderUserRole, Document


import json
from django.shortcuts import render, get_object_or_404, redirect
from .models import Document


import io
from django.shortcuts import render, get_object_or_404, redirect
from django.http import HttpResponse
from .models import Upload
import pandas as pd
import csv
import openpyxl

import csv
import io
from django.shortcuts import get_object_or_404, render
from django.http import HttpResponse
import openpyxl
from .models import Upload

import pandas as pd
from io import BytesIO
from django.shortcuts import get_object_or_404, render
from .models import Upload
import openpyxl

import pandas as pd
from io import BytesIO
from django.shortcuts import get_object_or_404, redirect
from .models import Upload
from django.db import connection
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



def get_user_role(user_id):
    with connection.cursor() as cursor:
        cursor.execute("SELECT role_id FROM USER_ROLES WHERE user_id = %s", [user_id])
        row = cursor.fetchone()
    if row:
        return row[0]
    return None

@login_required
def admin_view(request):
    role = get_user_role(request.user.id)
    if role != 1:
        return HttpResponseForbidden("You do not have permission to access this page.")
    return render(request, 'admin.html')


@login_required
def head_view(request):
    role = get_user_role(request.user.id)
    if role != 2:
        return HttpResponseForbidden("You do not have permission to access this page.")
    return render(request, 'head.html')


@login_required
def faculty_view(request):
    role = get_user_role(request.user.id)
    if role != 3:
        return HttpResponseForbidden("You do not have permission to access this page.")
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
    folders = Folder.objects.filter(is_active=1)
    return render(request, 'folder_list.html', {'folders': folders})


@login_required
def folder_documents(request, folder_id):
    folder = get_object_or_404(Folder, id=folder_id, is_active=True)
    documents = Document.objects.filter(folder_id=folder.id, is_deleted=False, folder__is_active=True)

    return render(request, 'documents.html', {
        'folder': folder,
        'documents': documents
    })


# -----------------------------
# Excel file download view
#
from django.http import HttpResponse
from django.shortcuts import get_object_or_404
from django.contrib.auth.decorators import login_required
from openpyxl import Workbook
from openpyxl.styles import Font
import json

from .models import Document

@login_required
def download_excel(request, doc_id):
    document = get_object_or_404(
        Document,
        id=doc_id,
        is_deleted=False,
        folder__is_active=True
    )

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

        # Create Excel workbook
        wb = Workbook()
        ws = wb.active
        ws.title = document.title
        ws.sheet_properties.tabColor = "1072BA"
        ws.freeze_panes = "A2"

        # Write column headers
        for index, col in enumerate(columns, start=1):
            name = col.get("name", "Unnamed")
            cell = ws.cell(row=1, column=index, value=name)
            cell.font = Font(bold=True)
            ws.column_dimensions[cell.column_letter].width = max(len(name) + 2, 20)

        # Prepare HTTP response
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
        print("Missing expected key:", ke)
        return HttpResponse(f"Missing expected key: {ke}", status=400)

    except Exception as e:
        print("Unexpected Error:", e)
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
    document = get_object_or_404(
        Document,
        id=doc_id,
        is_deleted=False,
        folder__is_active=True
    )
    raw_data = document.dynamic_data

    try:
        if isinstance(raw_data, str):
            raw_data = raw_data.replace('\n', '').replace('\r', '').strip()
        else:
            return HttpResponse("dynamic_data is not a string", status=400)

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
    user = request.user

    # Check if user is admin
    is_admin = FolderUserRole.objects.filter(
        user=user,
        role__role_name__iexact="admin"
    ).exists()

    if is_admin:
        # Admin sees all folders
        folders = Folder.objects.filter(is_active=True)
    else:
        # Non-admin sees only assigned folders
        folders = Folder.objects.filter(
            id__in=FolderUserRole.objects.filter(user=user).values_list('folder_id', flat=True), is_active=True
        ).distinct()

    return render(request, 'upload_file_list.html', {'folders': folders})

@login_required
def upload_document_list(request, folder_id):
    user = request.user

    # Check if user is allowed to see this folder
    is_admin = FolderUserRole.objects.filter(
        user=user,
        role__role_name__iexact="admin"
    ).exists()

    if not is_admin:
        has_access = FolderUserRole.objects.filter(user=user, folder_id=folder_id).exists()
        if not has_access:
            return HttpResponse("Unauthorized", status=403)

    folder = get_object_or_404(Folder, id=folder_id, is_active=True)
    documents = Document.objects.filter(folder_id=folder.id, is_deleted=False)
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

        folder = get_object_or_404(Folder, id=folder_id, is_active=True)
        document = get_object_or_404(Document, id=document_id, is_deleted=False)
        file_blob = uploaded_file.read()

        upload_instance = Upload.objects.create(
            document=document,
            folder=folder,
            uploaded_by=request.user,
            file_name=uploaded_file.name,
            file_blob=file_blob,
            file_size=uploaded_file.size,
            mime_type=uploaded_file.content_type,
            sha256_hash=hashlib.sha256(file_blob).hexdigest()
        )
        ActivityLog.objects.create(
            user=request.user,
            upload=upload_instance,
            file_name=upload_instance.file_name,
            action="UPLOAD"
        )


        return JsonResponse({'success': True})

    except Exception as e:
        return JsonResponse({'success': False, 'error': str(e)})

def get_visible_documents(user, folder):
    # Get roles for the user in this folder
    user_roles = FolderUserRole.objects.filter(user=user, folder=folder)

    # If the user is Head, return all documents
    if user_roles.filter(role__name='Head').exists():
        return Document.objects.filter(folder=folder, is_active=True)

    # If Faculty, return only assigned documents
    faculty_roles = user_roles.filter(role__name='Faculty', file__isnull=False, is_active=True, is_deleted=False)
    return Document.objects.filter(id__in=faculty_roles.values_list('file_id', flat=True), is_active=True, is_deleted=False)


@login_required
def assign_folder_role(request):
    admin_role_id = Role.objects.get(role_name__iexact="admin").role_id

    if request.method == "POST":
        user_id = request.POST.get("user_id")
        folder_id = request.POST.get("folder_id")
        role_id = int(request.POST.get("role_id"))
        file_id = request.POST.get("file_id") or None

        if user_id and role_id:
            try:
                if role_id == admin_role_id:
                    for folder in Folder.objects.filter(is_active=True):
                        FolderUserRole.objects.get_or_create(
                            user_id=user_id,
                            folder_id=folder.id,
                            role_id=role_id
                        )

                    for file in Document.objects.filter(is_deleted=False):
                        FolderUserRole.objects.get_or_create(
                            user_id=user_id,
                            file_id=file.id,
                            role_id=role_id
                        )

                    messages.success(request, "Admin role assigned with full access.")
                else:
                    exists = FolderUserRole.objects.filter(
                        user_id=user_id,
                        folder_id=folder_id,
                        file_id=file_id
                    ).exists()

                    if exists:
                        messages.warning(request, "This role assignment already exists.")
                    else:
                        FolderUserRole.objects.create(
                            user_id=user_id,
                            folder_id=folder_id,
                            file_id=file_id,
                            role_id=role_id,
                            assigned_at=now()
                        )
                        messages.success(request, "Role assigned successfully.")

            except Exception as e:
                messages.error(request, f"Error: {str(e)}")
        else:
            messages.error(request, "User and role are required.")

        return redirect('assign_folder_role')

    # GET request → show form only
    users = User.objects.all()
    folders = Folder.objects.filter(is_active=True)
    roles = Role.objects.all()
    documents = Document.objects.filter(is_deleted=False).select_related("folder")

    return render(request, "assign_folder_roles.html", {
        "users": users,
        "folders": folders,
        "roles": roles,
        "documents": documents,
    })

@login_required
def folder_role_assignments(request):
    assignments = FolderUserRole.objects.select_related("user", "folder", "role", "file").all()
    return render(request, "folder_role_assignments.html", {"assignments": assignments})

    # GET request
    users = User.objects.exclude(is_superuser=True)  # remove admin from user dropdown
    folders = Folder.objects.all()
    roles = Role.objects.all()
    documents = Document.objects.select_related('folder').all()
    assignments = FolderUserRole.objects.select_related('user', 'folder', 'role', 'file')

    return render(request, "assign_folder_roles.html", {
        "users": users,
        "folders": folders,
        "roles": roles,
        "assignments": assignments,
        "documents": documents
    })



@login_required
def remove_role(request, user_role_id):
    role_instance = get_object_or_404(FolderUserRole, id=user_role_id)

    # Check if removing last admin
    if role_instance.role.role_name.lower() == "admin":
        admin_count = FolderUserRole.objects.filter(role__role_name__iexact="admin").count()
        if admin_count <= 1:
            # First confirmation
            confirm1 = request.GET.get("confirm1")
            confirm2 = request.GET.get("confirm2")

            if not confirm1:
                messages.warning(request, "Are you sure you want to remove the LAST admin? Click again to confirm.")
                return redirect(f"{request.path}?confirm1=true")

            if not confirm2:
                messages.warning(request, "This is your FINAL confirmation. Click again to permanently remove.")
                return redirect(f"{request.path}?confirm1=true&confirm2=true")

    role_instance.delete()
    messages.success(request, "Role removed successfully.")
    return redirect("folder_role_assignments")

# def profile_view(request):
#     role_id = get_user_role_id(request.user.id)
#     print("DEBUG role_id from DB:", role_id, type(role_id))  # Check value and type
#     role_id = int(role_id) if role_id is not None else 0
#     return render(request, "profile.html", {"role_id": role_id})



def edit_list(request):
    folders = Folder.objects.filter(is_active=True)
    return render(request, 'edit_list.html', {'folders': folders})

def folder_documents_edit(request, folder_id):
    folder = get_object_or_404(Folder, id=folder_id, is_active=True)
    documents = Document.objects.filter(folder=folder, is_deleted=False, folder__is_active=True)
    return render(request, 'folder_documents.html', {
        'folder': folder,
        'documents': documents
    })

def edit_dynamic_table(request, doc_id):
    document = get_object_or_404(Document, id=doc_id, is_deleted=False)

    # Parse dynamic_data JSON
    dynamic_data = {}
    if document.dynamic_data:
        try:
            dynamic_data = json.loads(document.dynamic_data)
        except json.JSONDecodeError:
            dynamic_data = {}

    # The table name is the first key in the dict
    table_name = next(iter(dynamic_data.keys()), "")
    columns = dynamic_data.get(table_name, {}).get("columns", [])

    if request.method == "POST":
        # Handle remove column action
        if "remove_column" in request.POST:
            remove_index = int(request.POST.get("remove_column"))
            if 0 <= remove_index < len(columns):
                columns.pop(remove_index)

            # Save the updated JSON after deletion
            updated_data = {
                table_name: {
                    "columns": columns
                }
            }
            document.dynamic_data = json.dumps(updated_data, indent=4)
            document.save()

            return redirect("edit_dynamic_table", doc_id=doc_id)

        # Handle update action
        new_table_name = request.POST.get("table_name")
        new_columns = []
        total = int(request.POST.get("total_columns", 0))
        for i in range(total):
            col_name = request.POST.get(f"col_name_{i}")
            col_type = request.POST.get(f"col_type_{i}")
            col_constraints = request.POST.get(f"col_constraints_{i}", "")
            if col_name and col_type:
                col_data = {"name": col_name, "type": col_type}
                if col_constraints:
                    col_data["constraints"] = col_constraints
                new_columns.append(col_data)

        updated_data = {
            new_table_name: {
                "columns": new_columns
            }
        }

        document.dynamic_data = json.dumps(updated_data, indent=4)
        document.title = request.POST.get("title", document.title)
        document.description = request.POST.get("description", document.description)
        document.save()

        return redirect("edit_dynamic_table", doc_id=doc_id)

    return render(request, "edit_dynamic_table.html", {
        "document": document,
        "table_name": table_name,
        "columns": columns,
    })




from django.shortcuts import render
from django.contrib.auth.decorators import login_required
from django.db.models import Q
from .models import Upload, UserRole, FolderUserRole

@login_required
def history_index(request):
    user = request.user

    # Get user's role name
    try:
        role_name = UserRole.objects.select_related('role').get(user=user).role.role_name.lower()
    except UserRole.DoesNotExist:
        role_name = None

    if role_name == "admin":
        files = Upload.objects.select_related('uploaded_by', 'folder', 'document').filter(
            folder__is_active=True,
            document__is_deleted=False
        ).order_by('-upload_time')

    else:
        # Get folder IDs user has access to
        folder_ids = FolderUserRole.objects.filter(
            user=user,
            folder__isnull=False,
            folder__is_active=True
        ).values_list('folder_id', flat=True)

        # Get document IDs user has access to
        file_ids = FolderUserRole.objects.filter(
            user=user,
            file__isnull=False,
            file__is_deleted=False
        ).values_list('file_id', flat=True)

        # Query uploads where either:
        #   - Document is in allowed file_ids
        #   - Folder is in allowed folder_ids
        files = Upload.objects.select_related('uploaded_by', 'folder', 'document').filter(
            Q(document_id__in=file_ids) | Q(folder_id__in=folder_ids),
            folder__is_active=True,
            document__is_deleted=False
        ).order_by('-upload_time')

    return render(request, 'history_index.html', {'files': files})


import csv, io, openpyxl
from django.http import HttpResponse
from django.shortcuts import get_object_or_404, render
import mimetypes
from .models import Upload
@login_required
def history_view_file(request, file_id):
    file = get_object_or_404(
        Upload,
        id=file_id,
        folder__is_active=True,
        document__is_deleted=False
    )

    filename = file.file_name.lower()
    headers, rows = [], []

    try:
        if filename.endswith('.csv'):
            # Read CSV
            content = file.file_blob.decode('utf-8')
            reader = list(csv.reader(io.StringIO(content)))
            if reader:
                headers = reader[0]         # first row = headers
                rows = reader[1:]           # remaining rows = data

        elif filename.endswith('.xlsx'):
            # Read Excel
            in_memory_file = io.BytesIO(file.file_blob)
            wb = openpyxl.load_workbook(in_memory_file, data_only=True)
            sheet = wb.active
            data = list(sheet.iter_rows(values_only=True))

            if data:
                headers = [str(cell) if cell is not None else '' for cell in data[0]]
                rows = [
                    [str(cell) if cell is not None else '' for cell in row]
                    for row in data[1:]
                ]

        else:
            return render(request, 'history_view.html', {
                'file': file,
                'headers': None,
                'rows': None,
                'message': "Preview not supported for this file type."
            })

        return render(request, 'history_view.html', {
            'file': file,
            'headers': headers,
            'rows': rows
        })

    except Exception as e:
        return HttpResponse(f"Error while reading file: {e}")




from io import BytesIO
import pandas as pd
from docx import Document as DocxDocument
from django.shortcuts import get_object_or_404, render
from .models import Upload, ActivityLog

@login_required
def history_edit_file(request, file_id):
    file_obj = get_object_or_404(
        Upload,
        id=file_id,
        folder__is_active=True,
        document__is_deleted=False
    )

    extension = file_obj.file_name.lower().split('.')[-1]

    try:
        file_data = file_obj.file_blob
        file_stream = BytesIO(file_data)

        if extension == 'csv':
            df = pd.read_csv(file_stream)
            if df.empty:
                return render(request, 'history_edit.html', {'error': 'File is empty or unreadable.'})
            context = {
                'df': df.to_dict(orient='records'),
                'columns': df.columns,
                'file_id': file_id,
                'file_type': 'csv'
            }

        elif extension in ['xls', 'xlsx']:
            df = pd.read_excel(file_stream, engine='openpyxl')
            if df.empty:
                return render(request, 'history_edit.html', {'error': 'File is empty or unreadable.'})
            context = {
                'df': df.to_dict(orient='records'),
                'columns': df.columns,
                'file_id': file_id,
                'file_type': 'excel'
            }

        else:
            return render(request, 'history_edit.html', {'error': 'Unsupported file format'})

        # ✅ Activity log
        ActivityLog.objects.create(
            user=request.user,
            upload=file_obj,
            file_name=file_obj.file_name,
            action="EDIT"
        )

        return render(request, 'history_edit.html', context)

    except Exception as e:
        return render(request, 'history_edit.html', {
            'error': f'❌ Error reading file: {e}'
        })


@login_required
def history_save_file(request, file_id):
    file = get_object_or_404(
        Upload,
        id=file_id,
        folder__is_active=True,
        document__is_deleted=False
    )

    extension = file.file_name.lower().split('.')[-1]

    try:
        if extension in ['csv', 'xls', 'xlsx']:
            # ✅ Recreate DataFrame from POST data
            headers = request.POST.getlist('columns')
            total_rows = int(request.POST.get('total_rows', 0))

            rows = []
            for i in range(total_rows):
                row = [request.POST.get(f'{col}_{i}', '') for col in headers]
                rows.append(row)

            df = pd.DataFrame(rows, columns=headers)

            # ✅ Save updated file_blob
            if extension == 'csv':
                file.file_blob = df.to_csv(index=False, header=True).encode('utf-8')
            else:  # Excel (xls / xlsx)
                output = BytesIO()
                with pd.ExcelWriter(output, engine='openpyxl') as writer:
                    df.to_excel(writer, index=False, header=True)
                file.file_blob = output.getvalue()

            file.save()

            # ✅ Instead of going back → show updated preview
            return redirect('history_edit_file', file_id=file.id)

        else:
            return redirect('history_edit_file', file_id=file.id)

    except Exception as e:
        print("Error while saving file:", e)
        return redirect('history_edit_file', file_id=file.id)




from django.http import HttpResponse, Http404
from django.shortcuts import get_object_or_404

def history_download_file(request, file_id):
    file_obj = get_object_or_404(Upload, id=file_id)

    # Ensure file has data
    if not file_obj.file_blob:
        raise Http404("File is missing.")

    content_type = file_obj.mime_type or 'application/octet-stream'

    response = HttpResponse(file_obj.file_blob, content_type=content_type)
    response['Content-Disposition'] = f'attachment; filename="{file_obj.file_name or "download"}"'
    return response


@login_required
def history_delete_file(request, file_id):
    file_obj = get_object_or_404(Upload, id=file_id)
    file_obj.is_deleted = True
    file_obj.save()
    ActivityLog.objects.create(
        user=request.user,
        upload=file_obj,
        file_name=file_obj.file_name,
        action="DELETE",
        timestamp=timezone.now()
    )

    return redirect('history_index')

from django.utils import timezone
from django.contrib import messages
from django.shortcuts import redirect, render
from django.contrib.auth.decorators import login_required
from .models import Folder

@login_required
def edit_folders(request):
    if request.method == "POST":
        action = request.POST.get("action")

        if action == "add":
            folder_name = request.POST.get("folder_name")
            category = request.POST.get("category")
            if folder_name:
                Folder.objects.create(
                    folder_name=folder_name,
                    category=category or None,
                    created_at=timezone.now(),
                    updated_at=timezone.now(),
                    is_active=True,
                )
                messages.success(request, "Folder added successfully.")
            else:
                messages.error(request, "Folder name cannot be empty.")

        elif action == "delete":
            folder_id = request.POST.get("folder_id")
            folder = Folder.objects.filter(id=folder_id, is_active=True).first()
            if folder:
                # Soft delete folder
                folder.is_active = False
                folder.updated_at = timezone.now()
                folder.save()

                # Soft delete all related documents
                Document.objects.filter(folder=folder, is_deleted=False).update(
                    is_deleted=True,
                )

                messages.success(request, "Folder and its documents deleted successfully (soft delete).")
            else:
                messages.error(request, "Folder not found or already deleted.")

        return redirect("edit_folders")

    # Show only active + not deleted folders
    folders = Folder.objects.filter(is_active=True).order_by("folder_name")
    return render(request, "edit_folders.html", {"folders": folders})



# Manage documents within a folder: list, add, soft delete
@login_required
def edit_folder_documents(request, folder_id):
    folder = get_object_or_404(Folder, id=folder_id, is_active=True)  # ensure folder is active

    if request.method == "POST":
        if "add_document" in request.POST:
            title = request.POST.get("title")
            description = request.POST.get("description", "")
            if title:
                Document.objects.create(
                    title=title,
                    description=description,
                    folder=folder,
                    dynamic_data="{}",  # empty JSON
                    created_at=timezone.now(),
                    is_deleted=False  # default to active
                )
                messages.success(request, "Document added successfully.")
            else:
                messages.error(request, "Title is required.")
            return redirect("edit_folder_documents", folder_id=folder.id)

        elif "delete_document" in request.POST:
            doc_id = request.POST.get("doc_id")
            doc = Document.objects.filter(id=doc_id, folder=folder, is_deleted=False).first()
            if doc:
                doc.is_deleted = True
                doc.save(update_fields=["is_deleted"])
                messages.success(request, "Document marked as deleted.")
            else:
                messages.error(request, "Document not found or already deleted.")
            return redirect("edit_folder_documents", folder_id=folder.id)

    # Only show non-deleted documents
    documents = Document.objects.filter(folder=folder, is_deleted=False)

    return render(request, "edit_folder_documents.html", {
        "folder": folder,
        "documents": documents,
    })



from .models import ActivityLog

@login_required
def activity_log_view(request):
    if request.user.role != 'admin':  # only admin can see log
        return redirect('role_redirect')

    logs = ActivityLog.objects.select_related("user", "document").order_by("-timestamp")
    return render(request, "activity_log.html", {"logs": logs})



@login_required
def activity_log_view(request):
    logs = ActivityLog.objects.select_related("user", "upload").order_by("-timestamp")

    return render(request, "activity_log.html", {
        "logs": logs
    })


def history_restore_file(request, file_id):
    file_obj = get_object_or_404(Upload, id=file_id)
    file_obj.is_deleted = False
    file_obj.save()

    ActivityLog.objects.create(
        user=request.user,
        upload=file_obj,
        file_name=file_obj.file_name,
        action="RESTORE",
        timestamp=timezone.now()
    )
    return redirect('history_index')

from django.urls import reverse
def download_file(request, file_id):
    file_obj = get_object_or_404(Upload, id=file_id, is_deleted=False)
    response = HttpResponse(file_obj.file_blob, content_type=file_obj.mime_type)
    response['Content-Disposition'] = f'attachment; filename="{file_obj.file_name}"'
    return response


def uploaded_files(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    files = Upload.objects.filter(document=document, is_deleted=False)

    return render(request, 'uploaded_files.html', {
        'document': document,
        'files': files
    })

import io, csv, openpyxl
from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse
from django.contrib.auth.decorators import login_required
from .models import Upload

@login_required
def file_preview(request, file_id):
    file = get_object_or_404(
        Upload,
        id=file_id,
        folder__is_active=True,
        document__is_deleted=False
    )

    filename = file.file_name.lower()
    rows = []

    try:
        if filename.endswith('.csv'):
            content = file.file_blob.decode('utf-8')
            reader = csv.reader(io.StringIO(content))
            rows = list(reader)

            return render(request, 'preview.html', {
                'file': file,
                'rows': rows,
                'file_type': 'csv'
            })

        elif filename.endswith('.xlsx'):
            in_memory_file = io.BytesIO(file.file_blob)
            wb = openpyxl.load_workbook(in_memory_file)
            sheet = wb.active
            for row in sheet.iter_rows(values_only=True):
                rows.append([cell if cell is not None else '' for cell in row])

            return render(request, 'preview.html', {
                'file': file,
                'rows': rows,
                'file_type': 'xlsx'
            })

        else:
            return render(request, 'preview.html', {
                'file': file,
                'rows': None,
                'file_type': 'other'
            })

    except Exception as e:
        return HttpResponse(f"Error while reading file: {e}", status=500)

