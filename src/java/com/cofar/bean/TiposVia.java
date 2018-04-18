/*
 * TiposVenta.java
 *
 * Created on 17 de abril de 2008, 12:19
 */

package com.cofar.bean;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class TiposVia {
    
    /** Creates a new instance of TiposVenta */
    private String codTipoVia;
    private String nombreTipoVia="";
    private String obsTipoVia="";
    private int codEstadoRegistro;

 

    public String getNombreTipoVia() {
        return nombreTipoVia;
    }

    public void setNombreTipoVia(String nombreTipoVia) {
        this.nombreTipoVia = nombreTipoVia;
    }

    public String getObsTipoVia() {
        return obsTipoVia;
    }

    public void setObsTipoVia(String obsTipoVia) {
        this.obsTipoVia = obsTipoVia;
    }

    public int getCodEstadoRegistro() {
        return codEstadoRegistro;
    }

    public void setCodEstadoRegistro(int codEstadoRegistro) {
        this.codEstadoRegistro = codEstadoRegistro;
    }

    public String getCodTipoVia() {
        return codTipoVia;
    }

    public void setCodTipoVia(String codTipoVia) {
        this.codTipoVia = codTipoVia;
    }
    
   
}
