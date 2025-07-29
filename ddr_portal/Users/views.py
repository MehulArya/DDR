# your_app/views.py
from django.shortcuts import render, redirect
from django.contrib.auth import login, authenticate, logout
from .forms import CustomUserCreationForm, CustomLoginForm
from django.contrib.auth.decorators import login_required
from django.db import connection

def signup_view(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('role_redirect')  # or any landing page
    else:
        form = CustomUserCreationForm()
    return render(request, 'signup.html', {'form': form})

def login_view(request):
    if request.method == 'POST':
        form = CustomLoginForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('/role_redirect')  # or home page
    else:
        form = CustomLoginForm()
    return render(request, 'login.html', {'form': form})

def logout_view(request):
    logout(request)
    return redirect('login')

# @login_required
# def dashboard(request):
#     return render(request, 'dashboard.html')

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

    # Get role from USER_ROLES table
    with connection.cursor() as cursor:
        cursor.execute("SELECT role_id FROM USER_ROLES WHERE user_id = %s", [user_id])
        row = cursor.fetchone()

    if row:
        role_id = row[0]
        if role_id == 1:
            return redirect('admin')     # goes to path('Admin/', ...)
        elif role_id == 2:
            return redirect('head')      # goes to path('Head/', ...)
        elif role_id == 3:
            return redirect('faculty')   # goes to path('Faculty/', ...)
    
    return redirect('login')  # fallback
