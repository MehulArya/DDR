# your_app/urls.py
from django.urls import path
from . import views
from django.contrib.auth import views as auth_views



urlpatterns = [

    path('signup/', views.signup_view, name='signup'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    # path('dashboard/', views.dashboard, name='dashboard'),  # example
    path('custom_admin/', views.admin_view, name='admin'),
    path('head/', views.head_view, name='head'),
    path('faculty/', views.faculty_view, name='faculty'),
    path('role_redirect/', views.role_redirect, name='role_redirect'),
    path('folders/', views.folder_list, name='folder_list'),
    path('folders/<int:folder_id>/', views.folder_documents, name='folder_documents'),
    path('password-reset/',
         auth_views.PasswordResetView.as_view(template_name='password_reset.html'),
         name='password_reset'),

    path('password-reset/done/',
         auth_views.PasswordResetDoneView.as_view(template_name='password_reset_done.html'),
         name='password_reset_done'),

    path('reset/<uidb64>/<token>/',
         auth_views.PasswordResetConfirmView.as_view(template_name='password_reset_confirm.html'),
         name='password_reset_confirm'),

    path('reset/done/',
         auth_views.PasswordResetCompleteView.as_view(template_name='password_reset_complete.html'),
         name='password_reset_complete'),

    path('download-excel/<int:doc_id>/', views.download_excel, name='download_excel'),
    path('profile/', views.profile_view, name='profile'),

    path('see-template/<int:doc_id>/', views.see_template, name='see_template'),
    #these are used to upload the new folders
    path('upload/', views.upload_folder_list, name='upload_folder_list'),  # → uses upload_file_list.html

    # Step 2: Show documents in selected folder
    path('upload/folder/<int:folder_id>/', views.upload_document_list, name='upload_document_list'),  # → uses upload_document_list.html

    # Step 3: Upload file to specific document

    path('upload/ajax/', views.ajax_upload_file, name='ajax_upload_file'),
      path('profile/', views.profile_view, name='profile'),

    path("assign_roles/", views.assign_folder_role, name="assign_folder_role"),
    path('remove-role/<int:user_role_id>/', views.remove_role, name='remove_role'),
]

