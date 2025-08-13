# your_app/urls.py
from . import views
from django.urls import path
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
   
    path('upload/', views.upload_folder_list, name='upload_folder_list'),  # → uses upload_file_list.html

  
    path('upload/folder/<int:folder_id>/', views.upload_document_list, name='upload_document_list'),  # → uses upload_document_list.html

   

    path('upload/ajax/', views.ajax_upload_file, name='ajax_upload_file'),
    path('profile/', views.profile_view, name='profile'),

    path("assign_roles/", views.assign_folder_role, name="assign_folder_role"),
    path('remove-role/<int:user_role_id>/', views.remove_role, name='remove_role'),
    path('edit_list/', views.edit_list, name='edit_list'),
    path('folder/<int:folder_id>/', views.folder_documents_edit, name='folder_edit_documents'),
    path('edit_dynamic_table/<int:doc_id>/', views.edit_dynamic_table, name='edit_dynamic_table'),
    path('edit_folders/', views.edit_folders, name='edit_folders'),
    path('edit_folders/<int:folder_id>/', views.edit_folder_documents, name='edit_folder_documents'),


    path('View History/', views.history_index, name='history_index'),
    path('history/view/<int:file_id>/', views.history_view_file, name='history_view_file'),
    path('history/edit/<int:file_id>/', views.history_edit_file, name='history_edit_file'),
    path('history/save/<int:file_id>/', views.history_save_file, name='history_save_file'),
    path('history/download/<int:file_id>/', views.history_download_file, name='history_download_file'),
    path('history/delete/<int:file_id>/', views.history_delete_file, name='history_delete_file'),

]