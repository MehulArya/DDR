# models.py
from django.db import models
from django.contrib.auth.models import User

class Upload(models.Model):
    id = models.AutoField(primary_key=True)
    document = models.ForeignKey('Document', on_delete=models.CASCADE)
    folder = models.ForeignKey('Folder', on_delete=models.CASCADE)
    uploaded_by = models.ForeignKey(User, on_delete=models.CASCADE)
    upload_time = models.DateTimeField(auto_now_add=True)
    file_name = models.CharField(max_length=255)
    file_blob = models.BinaryField()
    file_size = models.BigIntegerField(null=True, blank=True)
    mime_type = models.CharField(max_length=255, null=True, blank=True)
    sha256_hash = models.CharField(max_length=64, null=True, blank=True)

    class Meta:
        db_table = 'UPLOADS'
        managed = False  # ✅ because you're using an existing SQL Server table

    def __str__(self):
        return self.file_name

class Folder(models.Model):
    id = models.AutoField(primary_key=True)
    folder_name = models.CharField(max_length=255)
    parent = models.ForeignKey('self', on_delete=models.SET_NULL, null=True, blank=True)
    category = models.CharField(max_length=100, blank=True, null=True)
    created_at = models.DateTimeField()
    updated_at = models.DateTimeField()
    is_active = models.BooleanField(default=True)

    class Meta:
        db_table = 'FOLDERS'
        managed = False

    def __str__(self):
        return self.folder_name

class Document(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    folder = models.ForeignKey(Folder, on_delete=models.CASCADE)
    dynamic_data = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField()

    class Meta:
        db_table = 'DOCUMENTS'
        managed = False

    def __str__(self):
        return self.title



class Upload(models.Model):
    id = models.AutoField(primary_key=True)
    document = models.ForeignKey('Document', on_delete=models.CASCADE, db_column='document_id')
    folder = models.ForeignKey('Folder', on_delete=models.CASCADE, db_column='folder_id')
    uploaded_by = models.ForeignKey(User, on_delete=models.CASCADE, db_column='uploaded_by')  # ✅ FIX HERE
    upload_time = models.DateTimeField(auto_now_add=True)
    file_name = models.CharField(max_length=255)
    file_blob = models.BinaryField()
    file_size = models.BigIntegerField(null=True, blank=True)
    mime_type = models.CharField(max_length=255, null=True, blank=True)
    sha256_hash = models.CharField(max_length=64, null=True, blank=True)

    class Meta:
        db_table = 'UPLOADS'
        managed = False

    def __str__(self):
        return self.file_name



from django.db import models
from django.contrib.auth.models import User

class Role(models.Model):
    role_id = models.IntegerField(primary_key=True, db_column='role_id')
    role_name = models.CharField(max_length=50)

    class Meta:
        db_table = 'ROLES'
        managed = False

    def __str__(self):
        return self.role_name


class UserRole(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, db_column='user_id', primary_key=True)
    role = models.ForeignKey(Role, on_delete=models.CASCADE, db_column='role_id')

    class Meta:
        db_table = 'USER_ROLES'
        managed = False

        