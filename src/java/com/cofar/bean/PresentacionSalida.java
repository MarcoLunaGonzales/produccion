/*
 * PresentacionSalida.java
 *
 * Created on 11 de octubre de 2010, 05:10 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

public class PresentacionSalida extends AbstractBean{
    private int codAlmacen;
    private int codSalidaAlmacen;
    private int codProd;
    private String FechaSalidaAlmacen = "";
    private String codLoteProduccion = "";
    /** Creates a new instance of PresentacionSalida */
    public PresentacionSalida() {
    }

    public int getCodAlmacen() {
        return codAlmacen;
    }

    public void setCodAlmacen(int codAlmacen) {
        this.codAlmacen = codAlmacen;
    }

    public int getCodSalidaAlmacen() {
        return codSalidaAlmacen;
    }

    public void setCodSalidaAlmacen(int codSalidaAlmacen) {
        this.codSalidaAlmacen = codSalidaAlmacen;
    }

    public int getCodProd() {
        return codProd;
    }

    public void setCodProd(int codProd) {
        this.codProd = codProd;
    }

    public String getFechaSalidaAlmacen() {
        return FechaSalidaAlmacen;
    }

    public void setFechaSalidaAlmacen(String FechaSalidaAlmacen) {
        this.FechaSalidaAlmacen = FechaSalidaAlmacen;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }
    
}
