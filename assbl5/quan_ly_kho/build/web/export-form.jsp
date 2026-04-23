<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo phiếu xuất</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>body{background:#f5f7fb}.card-main{border:0;border-radius:18px;box-shadow:0 8px 24px rgba(15,23,42,.06)}</style>
</head>
<body>
    <%@ include file="includes/navbar.jspf" %>
    <div class="container py-4">
        <div class="card card-main">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold mb-1">Tạo phiếu xuất</h3>
                        <p class="text-muted mb-0">Sau khi lưu, hệ thống tự trừ tồn kho và ghi vào lịch sử kho.</p>
                    </div>
                </div>
                <c:if test="${param.msg == 'created'}"><div class="alert alert-success">Tạo phiếu xuất thành công. Mã phiếu: <b>${param.code}</b></div></c:if>
                <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

                <form action="exports" method="post">
                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Khách hàng</label>
                            <input class="form-control" name="customerName" placeholder="Tên khách hàng / đơn vị nhận hàng">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ghi chú</label>
                            <input class="form-control" name="note" placeholder="Ghi chú phiếu xuất">
                        </div>
                    </div>

                    <div class="table-responsive mb-3">
                        <table class="table table-bordered align-middle" id="itemTable">
                            <thead class="table-light">
                                <tr>
                                    <th style="width:38%">Sản phẩm</th>
                                    <th style="width:16%">Tồn hiện tại</th>
                                    <th style="width:14%">Số lượng</th>
                                    <th style="width:16%">Đơn giá xuất</th>
                                    <th style="width:14%">Thành tiền</th>
                                    <th style="width:2%"></th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                    <button type="button" class="btn btn-outline-primary mb-3" onclick="addRow()">+ Thêm dòng</button>
                    <div class="fw-bold fs-5 mb-3">Tổng tiền: <span id="grandTotal">0</span></div>
                    <button class="btn btn-success">Lưu phiếu xuất</button>
                </form>
            </div>
        </div>
    </div>

    <template id="rowTemplate">
        <tr>
            <td>
                <select class="form-select product-select" name="productId" onchange="syncPrice(this)">
                    <option value="">-- Chọn sản phẩm --</option>
                    <c:forEach var="p" items="${products}">
                        <option value="${p.maSanPham}" data-export-price="${p.giaXuat}" data-stock="${p.soLuongTon}">${p.maHang} - ${p.tenSanPham}</option>
                    </c:forEach>
                </select>
            </td>
            <td><input type="text" class="form-control stock-view" readonly></td>
            <td><input type="number" class="form-control qty-input" name="quantity" min="1" value="1" oninput="calcRow(this)"></td>
            <td><input type="number" step="0.01" class="form-control price-input" name="unitPrice" min="0" oninput="calcRow(this)"></td>
            <td><input type="text" class="form-control line-total" readonly></td>
            <td><button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">x</button></td>
        </tr>
    </template>

    <script>
        function addRow() {
            const tpl = document.getElementById('rowTemplate').content.cloneNode(true);
            document.querySelector('#itemTable tbody').appendChild(tpl);
        }
        function removeRow(btn) {
            btn.closest('tr').remove();
            calcGrandTotal();
        }
        function syncPrice(select) {
            const row = select.closest('tr');
            const opt = select.options[select.selectedIndex];
            row.querySelector('.price-input').value = opt.dataset.exportPrice || 0;
            row.querySelector('.stock-view').value = opt.dataset.stock || 0;
            calcRow(row.querySelector('.price-input'));
        }
        function calcRow(el) {
            const row = el.closest('tr');
            const qty = parseFloat(row.querySelector('.qty-input').value || 0);
            const price = parseFloat(row.querySelector('.price-input').value || 0);
            row.querySelector('.line-total').value = (qty * price).toLocaleString('vi-VN');
            calcGrandTotal();
        }
        function calcGrandTotal() {
            let total = 0;
            document.querySelectorAll('#itemTable tbody tr').forEach(row => {
                const qty = parseFloat(row.querySelector('.qty-input').value || 0);
                const price = parseFloat(row.querySelector('.price-input').value || 0);
                total += qty * price;
            });
            document.getElementById('grandTotal').innerText = total.toLocaleString('vi-VN');
        }
        addRow();
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
