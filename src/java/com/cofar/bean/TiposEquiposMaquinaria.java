/*
 * TiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class TiposEquiposMaquinaria {
    
    /** Creates a new instance of TiposMercaderia */
    private String codTipoEquipo="";
    private String nombreTipoEquipo="";
    private String obsTipoEquipo="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    private Boolean checked=new Boolean (false);

    public String getCodTipoEquipo() {
        return codTipoEquipo;
    }

    public void setCodTipoEquipo(String codTipoEquipo) {
        this.codTipoEquipo = codTipoEquipo;
    }

    public String getNombreTipoEquipo() {
        return nombreTipoEquipo;
    }

    public void setNombreTipoEquipo(String nombreTipoEquipo) {
        this.nombreTipoEquipo = nombreTipoEquipo;
    }

    public String getObsTipoEquipo() {
        return obsTipoEquipo;
    }

    public void setObsTipoEquipo(String obsTipoEquipo) {
        this.obsTipoEquipo = obsTipoEquipo;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }
    
   
}
