<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                                    <th style="width:14%">Số lượng</th>
                                    <th style="width:16%">Đơn giá xuất</th>
                                    <th style="width:14%">Thành tiền</th>
                                    <th style="width:2%"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="row" items="${rows}" varStatus="st">
                                    <tr>
                                        <td>
                                            <select class="form-select" name="productId">
                                                <option value="">-- Chọn sản phẩm --</option>
                                                <c:forEach var="p" items="${products}">
                                                    <option value="${p.maSanPham}" ${p.maSanPham == row.productId ? 'selected' : ''}>${p.maHang} - ${p.tenSanPham}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                       
                                        <td>
                                            <input type="number" class="form-control" name="quantity" min="1" value="${row.quantity}">
                                        </td>
                                        <td>
                                            <input type="number" step="0.01" class="form-control" name="unitPrice" min="0" value="${row.unitPrice}">
                                        </td>
                                        <td>
                                            <fmt:formatNumber var="lineTotalFmt" value="${row.lineTotal}" type="number" groupingUsed="true"/>
                                            <input type="text" class="form-control" readonly value="${lineTotalFmt}">
                                        </td>
                                        <td>
                                            <button type="submit" class="btn btn-sm btn-danger" formaction="exports?action=remove&index=${st.index}">x</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="d-flex gap-2 flex-wrap mb-3">
                        <button type="submit" class="btn btn-outline-primary" name="action" value="addRow">+ Thêm dòng</button>
                        <button type="submit" class="btn btn-outline-secondary" name="action" value="refresh">Tính tiền</button>
                    </div>
                    <div class="fw-bold fs-5 mb-3">
                        Tổng tiền:
                        <span>
                            <fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/>
                        </span>
                    </div>
                    <button class="btn btn-success" type="submit" name="action" value="create">Lưu phiếu xuất</button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<%-- <td>
                                            <input type="text" class="form-control" readonly value="${row.stock}">
                                        </td> --%>