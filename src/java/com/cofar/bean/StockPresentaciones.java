/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class StockPresentaciones {
    int codPresentacion = 0;
    AreasEmpresa areasEmpresa = new AreasEmpresa();
    double stockMinimo = 0;
    double stockSeguridad = 0;
    double stockMaximo = 0;
    double stockReposicion = 0;
    double diferenciaReposicion = 0;
    double diferenciaMinima = 0;
    double cantDisponible = 0;
    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public int getCodPresentacion() {
        return codPresentacion;
    }

    public void setCodPresentacion(int codPresentacion) {
        this.codPresentacion = codPresentacion;
    }

    public double getStockMaximo() {
        return stockMaximo;
    }

    public void setStockMaximo(double stockMaximo) {
        this.stockMaximo = stockMaximo;
    }

    public double getStockMinimo() {
        return stockMinimo;
    }

    public void setStockMinimo(double stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    public double getStockReposicion() {
        return stockReposicion;
    }

    public void setStockReposicion(double stockReposicion) {
        this.stockReposicion = stockReposicion;
    }

    public double getStockSeguridad() {
        return stockSeguridad;
    }

    public void setStockSeguridad(double stockSeguridad) {
        this.stockSeguridad = stockSeguridad;
    }

    public double getDiferenciaMinima() {
        return diferenciaMinima;
    }

    public void setDiferenciaMinima(double diferenciaMinima) {
        this.diferenciaMinima = diferenciaMinima;
    }

    public double getDiferenciaReposicion() {
        return diferenciaReposicion;
    }

    public void setDiferenciaReposicion(double diferenciaReposicion) {
        this.diferenciaReposicion = diferenciaReposicion;
    }

    public double getCantDisponible() {
        return cantDisponible;
    }

    public void setCantDisponible(double cantDisponible) {
        this.cantDisponible = cantDisponible;
    }
    

    
    

    

}
