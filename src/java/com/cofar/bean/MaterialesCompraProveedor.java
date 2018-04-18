/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class MaterialesCompraProveedor extends AbstractBean
{
    private int codMaterialCompraProveedor=0;
    private Materiales materiales=new Materiales();
    private Proveedores proveedores=new Proveedores();
    private Date fechaHabilitacion=new Date();
    public MaterialesCompraProveedor() {
    }

    public int getCodMaterialCompraProveedor() {
        return codMaterialCompraProveedor;
    }

    public void setCodMaterialCompraProveedor(int codMaterialCompraProveedor) {
        this.codMaterialCompraProveedor = codMaterialCompraProveedor;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public Proveedores getProveedores() {
        return proveedores;
    }

    public void setProveedores(Proveedores proveedores) {
        this.proveedores = proveedores;
    }

    public Date getFechaHabilitacion() {
        return fechaHabilitacion;
    }

    public void setFechaHabilitacion(Date fechaHabilitacion) {
        this.fechaHabilitacion = fechaHabilitacion;
    }
    
    
    
}
