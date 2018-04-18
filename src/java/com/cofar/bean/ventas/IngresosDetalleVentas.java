/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.ventas;

import com.cofar.bean.AbstractBean;
import com.cofar.bean.PresentacionesProducto;
import java.util.Date;

/**
 *
 * @author DASISAQ
 */
public class IngresosDetalleVentas extends AbstractBean
{
    private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
    private String codLoteProduccion="";
    private Double cantidad=0d;
    private Double cantidadUnitaria=0d;
    private Date fechaVencimiento=new Date();

    public IngresosDetalleVentas() {
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public Double getCantidadUnitaria() {
        return cantidadUnitaria;
    }

    public void setCantidadUnitaria(Double cantidadUnitaria) {
        this.cantidadUnitaria = cantidadUnitaria;
    }
    
    
    
}
