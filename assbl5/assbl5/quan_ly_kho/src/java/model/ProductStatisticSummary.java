package model;

public class ProductStatisticSummary {
    private int totalProducts;
    private int totalStockQuantity;
    private double totalInventoryValue;
    private int totalImportQuantity;
    private double totalImportValue;
    private int totalExportQuantity;
    private double totalExportValue;
    private int lowStockCount;
    private int outOfStockCount;

    public int getTotalProducts() {
        return totalProducts;
    }

    public void setTotalProducts(int totalProducts) {
        this.totalProducts = totalProducts;
    }

    public int getTotalStockQuantity() {
        return totalStockQuantity;
    }

    public void setTotalStockQuantity(int totalStockQuantity) {
        this.totalStockQuantity = totalStockQuantity;
    }

    public double getTotalInventoryValue() {
        return totalInventoryValue;
    }

    public void setTotalInventoryValue(double totalInventoryValue) {
        this.totalInventoryValue = totalInventoryValue;
    }

    public int getTotalImportQuantity() {
        return totalImportQuantity;
    }

    public void setTotalImportQuantity(int totalImportQuantity) {
        this.totalImportQuantity = totalImportQuantity;
    }

    public double getTotalImportValue() {
        return totalImportValue;
    }

    public void setTotalImportValue(double totalImportValue) {
        this.totalImportValue = totalImportValue;
    }

    public int getTotalExportQuantity() {
        return totalExportQuantity;
    }

    public void setTotalExportQuantity(int totalExportQuantity) {
        this.totalExportQuantity = totalExportQuantity;
    }

    public double getTotalExportValue() {
        return totalExportValue;
    }

    public void setTotalExportValue(double totalExportValue) {
        this.totalExportValue = totalExportValue;
    }

    public int getLowStockCount() {
        return lowStockCount;
    }

    public void setLowStockCount(int lowStockCount) {
        this.lowStockCount = lowStockCount;
    }

    public int getOutOfStockCount() {
        return outOfStockCount;
    }

    public void setOutOfStockCount(int outOfStockCount) {
        this.outOfStockCount = outOfStockCount;
    }
}
