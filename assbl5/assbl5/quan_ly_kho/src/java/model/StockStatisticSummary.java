package model;

public class StockStatisticSummary {
    private int importReceiptCount;
    private int importQuantity;
    private double importAmount;
    private int exportReceiptCount;
    private int exportQuantity;
    private double exportAmount;

    public int getImportReceiptCount() {
        return importReceiptCount;
    }

    public void setImportReceiptCount(int importReceiptCount) {
        this.importReceiptCount = importReceiptCount;
    }

    public int getImportQuantity() {
        return importQuantity;
    }

    public void setImportQuantity(int importQuantity) {
        this.importQuantity = importQuantity;
    }

    public double getImportAmount() {
        return importAmount;
    }

    public void setImportAmount(double importAmount) {
        this.importAmount = importAmount;
    }

    public int getExportReceiptCount() {
        return exportReceiptCount;
    }

    public void setExportReceiptCount(int exportReceiptCount) {
        this.exportReceiptCount = exportReceiptCount;
    }

    public int getExportQuantity() {
        return exportQuantity;
    }

    public void setExportQuantity(int exportQuantity) {
        this.exportQuantity = exportQuantity;
    }

    public double getExportAmount() {
        return exportAmount;
    }

    public void setExportAmount(double exportAmount) {
        this.exportAmount = exportAmount;
    }

    public int getNetQuantity() {
        return importQuantity - exportQuantity;
    }

    public double getNetAmount() {
        return importAmount - exportAmount;
    }
}
