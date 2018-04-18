/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.ventas;

import com.cofar.bean.AbstractBean;

/**
 *
 * @author DASISAQ
 */
public class AlmacenesVentas extends AbstractBean
{
    private int codAlmacenVenta=0;
    private String nombreAlmacenVenta="";

    public AlmacenesVentas() {
    }

    public int getCodAlmacenVenta() {
        return codAlmacenVenta;
    }

    public void setCodAlmacenVenta(int codAlmacenVenta) {
        this.codAlmacenVenta = codAlmacenVenta;
    }

    public String getNombreAlmacenVenta() {
        return nombreAlmacenVenta;
    }

    public void setNombreAlmacenVenta(String nombreAlmacenVenta) {
        this.nombreAlmacenVenta = nombreAlmacenVenta;
    }
    
    
}
