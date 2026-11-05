import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../models/labour_model.dart';
import '../models/attendance_model.dart';
import '../models/inventory_model.dart';
import '../models/supplier_model.dart';
import '../models/purchase_model.dart';
import '../models/income_model.dart';
import '../models/expense_model.dart';
import '../models/notification_model.dart';
import '../core/constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== PROJECTS ====================

  // Create project
  Future<String> createProject(ProjectModel project) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.projectsCollection)
          .add(project.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to create project.';
    }
  }

  // Get all projects
  Stream<List<ProjectModel>> getProjects() {
    return _firestore
        .collection(AppConstants.projectsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromFirestore(doc))
            .toList());
  }

  // Get project by ID
  Future<ProjectModel?> getProjectById(String projectId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.projectsCollection)
          .doc(projectId)
          .get();
      if (doc.exists) {
        return ProjectModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch project.';
    }
  }

  // Update project
  Future<void> updateProject(String projectId, ProjectModel project) async {
    try {
      await _firestore
          .collection(AppConstants.projectsCollection)
          .doc(projectId)
          .update(project.toFirestore());
    } catch (e) {
      throw 'Failed to update project.';
    }
  }

  // Delete project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore
          .collection(AppConstants.projectsCollection)
          .doc(projectId)
          .delete();
    } catch (e) {
      throw 'Failed to delete project.';
    }
  }

  // Search projects
  Stream<List<ProjectModel>> searchProjects(String query) {
    return _firestore
        .collection(AppConstants.projectsCollection)
        .orderBy('projectName')
        .startAt([query])
        .endAt([query + ''])
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromFirestore(doc))
            .toList());
  }

  // ==================== LABOUR ====================

  // Create labour
  Future<String> createLabour(LabourModel labour) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.labourCollection)
          .add(labour.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add worker.';
    }
  }

  // Get all labour
  Stream<List<LabourModel>> getLabour() {
    return _firestore
        .collection(AppConstants.labourCollection)
        .where('isActive', isEqualTo: true)
        .orderBy('workerName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LabourModel.fromFirestore(doc))
            .toList());
  }

  // Get labour by ID
  Future<LabourModel?> getLabourById(String labourId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.labourCollection)
          .doc(labourId)
          .get();
      if (doc.exists) {
        return LabourModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch worker.';
    }
  }

  // Update labour
  Future<void> updateLabour(String labourId, LabourModel labour) async {
    try {
      await _firestore
          .collection(AppConstants.labourCollection)
          .doc(labourId)
          .update(labour.toFirestore());
    } catch (e) {
      throw 'Failed to update worker.';
    }
  }

  // Delete labour
  Future<void> deleteLabour(String labourId) async {
    try {
      await _firestore
          .collection(AppConstants.labourCollection)
          .doc(labourId)
          .update({'isActive': false});
    } catch (e) {
      throw 'Failed to delete worker.';
    }
  }

  // ==================== ATTENDANCE ====================

  // Mark attendance
  Future<String> markAttendance(AttendanceModel attendance) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.attendanceCollection)
          .add(attendance.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to mark attendance.';
    }
  }

  // Get attendance by date
  Stream<List<AttendanceModel>> getAttendanceByDate(DateTime date) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.attendanceCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(doc))
            .toList());
  }

  // Get attendance by project and date
  Stream<List<AttendanceModel>> getAttendanceByProjectAndDate(
    String projectId,
    DateTime date,
  ) {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.attendanceCollection)
        .where('projectId', isEqualTo: projectId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(doc))
            .toList());
  }

  // Get attendance by labour and date range
  Stream<List<AttendanceModel>> getAttendanceByLabourAndDateRange(
    String labourId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _firestore
        .collection(AppConstants.attendanceCollection)
        .where('labourId', isEqualTo: labourId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceModel.fromFirestore(doc))
            .toList());
  }

  // Update attendance
  Future<void> updateAttendance(String attendanceId, AttendanceModel attendance) async {
    try {
      await _firestore
          .collection(AppConstants.attendanceCollection)
          .doc(attendanceId)
          .update(attendance.toFirestore());
    } catch (e) {
      throw 'Failed to update attendance.';
    }
  }

  // ==================== INVENTORY ====================

  // Create inventory item
  Future<String> createInventoryItem(InventoryModel inventory) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.inventoryCollection)
          .add(inventory.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add inventory item.';
    }
  }

  // Get inventory by project
  Stream<List<InventoryModel>> getInventoryByProject(String projectId) {
    return _firestore
        .collection(AppConstants.inventoryCollection)
        .where('projectId', isEqualTo: projectId)
        .orderBy('materialName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryModel.fromFirestore(doc))
            .toList());
  }

  // Get low stock items
  Stream<List<InventoryModel>> getLowStockItems(String projectId) {
    return _firestore
        .collection(AppConstants.inventoryCollection)
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryModel.fromFirestore(doc))
            .where((item) => item.isLowStock)
            .toList());
  }

  // Update inventory
  Future<void> updateInventory(String inventoryId, InventoryModel inventory) async {
    try {
      await _firestore
          .collection(AppConstants.inventoryCollection)
          .doc(inventoryId)
          .update(inventory.toFirestore());
    } catch (e) {
      throw 'Failed to update inventory.';
    }
  }

  // Delete inventory
  Future<void> deleteInventory(String inventoryId) async {
    try {
      await _firestore
          .collection(AppConstants.inventoryCollection)
          .doc(inventoryId)
          .delete();
    } catch (e) {
      throw 'Failed to delete inventory item.';
    }
  }

  // ==================== SUPPLIERS ====================

  // Create supplier
  Future<String> createSupplier(SupplierModel supplier) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.suppliersCollection)
          .add(supplier.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add supplier.';
    }
  }

  // Get all suppliers
  Stream<List<SupplierModel>> getSuppliers() {
    return _firestore
        .collection(AppConstants.suppliersCollection)
        .orderBy('supplierName')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SupplierModel.fromFirestore(doc))
            .toList());
  }

  // Update supplier
  Future<void> updateSupplier(String supplierId, SupplierModel supplier) async {
    try {
      await _firestore
          .collection(AppConstants.suppliersCollection)
          .doc(supplierId)
          .update(supplier.toFirestore());
    } catch (e) {
      throw 'Failed to update supplier.';
    }
  }

  // Delete supplier
  Future<void> deleteSupplier(String supplierId) async {
    try {
      await _firestore
          .collection(AppConstants.suppliersCollection)
          .doc(supplierId)
          .delete();
    } catch (e) {
      throw 'Failed to delete supplier.';
    }
  }

  // ==================== PURCHASES ====================

  // Create purchase
  Future<String> createPurchase(PurchaseModel purchase) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.purchasesCollection)
          .add(purchase.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add purchase.';
    }
  }

  // Get purchases by project
  Stream<List<PurchaseModel>> getPurchasesByProject(String projectId) {
    return _firestore
        .collection(AppConstants.purchasesCollection)
        .where('projectId', isEqualTo: projectId)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PurchaseModel.fromFirestore(doc))
            .toList());
  }

  // Get all purchases
  Stream<List<PurchaseModel>> getAllPurchases() {
    return _firestore
        .collection(AppConstants.purchasesCollection)
        .orderBy('purchaseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PurchaseModel.fromFirestore(doc))
            .toList());
  }

  // ==================== INCOME ====================

  // Create income
  Future<String> createIncome(IncomeModel income) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.incomeCollection)
          .add(income.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add income.';
    }
  }

  // Get income by project
  Stream<List<IncomeModel>> getIncomeByProject(String projectId) {
    return _firestore
        .collection(AppConstants.incomeCollection)
        .where('projectId', isEqualTo: projectId)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IncomeModel.fromFirestore(doc))
            .toList());
  }

  // Get all income
  Stream<List<IncomeModel>> getAllIncome() {
    return _firestore
        .collection(AppConstants.incomeCollection)
        .orderBy('paymentDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IncomeModel.fromFirestore(doc))
            .toList());
  }

  // Update income
  Future<void> updateIncome(String incomeId, IncomeModel income) async {
    try {
      await _firestore
          .collection(AppConstants.incomeCollection)
          .doc(incomeId)
          .update(income.toFirestore());
    } catch (e) {
      throw 'Failed to update income.';
    }
  }

  // Delete income
  Future<void> deleteIncome(String incomeId) async {
    try {
      await _firestore
          .collection(AppConstants.incomeCollection)
          .doc(incomeId)
          .delete();
    } catch (e) {
      throw 'Failed to delete income.';
    }
  }

  // ==================== EXPENSES ====================

  // Create expense
  Future<String> createExpense(ExpenseModel expense) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.expensesCollection)
          .add(expense.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to add expense.';
    }
  }

  // Get expenses by project
  Stream<List<ExpenseModel>> getExpensesByProject(String projectId) {
    return _firestore
        .collection(AppConstants.expensesCollection)
        .where('projectId', isEqualTo: projectId)
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromFirestore(doc))
            .toList());
  }

  // Get all expenses
  Stream<List<ExpenseModel>> getAllExpenses() {
    return _firestore
        .collection(AppConstants.expensesCollection)
        .orderBy('expenseDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ExpenseModel.fromFirestore(doc))
            .toList());
  }

  // Update expense
  Future<void> updateExpense(String expenseId, ExpenseModel expense) async {
    try {
      await _firestore
          .collection(AppConstants.expensesCollection)
          .doc(expenseId)
          .update(expense.toFirestore());
    } catch (e) {
      throw 'Failed to update expense.';
    }
  }

  // Delete expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore
          .collection(AppConstants.expensesCollection)
          .doc(expenseId)
          .delete();
    } catch (e) {
      throw 'Failed to delete expense.';
    }
  }

  // ==================== NOTIFICATIONS ====================

  // Create notification
  Future<String> createNotification(NotificationModel notification) async {
    try {
      DocumentReference doc = await _firestore
          .collection(AppConstants.notificationsCollection)
          .add(notification.toFirestore());
      return doc.id;
    } catch (e) {
      throw 'Failed to create notification.';
    }
  }

  // Get user notifications
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection(AppConstants.notificationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(AppConstants.notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw 'Failed to update notification.';
    }
  }

  // Mark all notifications as read
  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.notificationsCollection)
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw 'Failed to update notifications.';
    }
  }
}
