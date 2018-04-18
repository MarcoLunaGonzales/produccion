/*
 * TiposMercaderia.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class TiposMercaderia {
    
    /** Creates a new instance of TiposMercaderia */
    private String codTipoMercaderia="";
    private String nombreTipoMercaderia="";
    private String obsTipoMercaderia="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    private Boolean checked=new Boolean (false);
    
    public TiposMercaderia() {
        
    }

    public String getCodTipoMercaderia() {
        return codTipoMercaderia;
    }

    public void setCodTipoMercaderia(String codTipoMercaderia) {
        this.codTipoMercaderia = codTipoMercaderia;
    }

    public String getNombreTipoMercaderia() {
        return nombreTipoMercaderia;
    }

    public void setNombreTipoMercaderia(String nombreTipoMercaderia) {
        this.nombreTipoMercaderia = nombreTipoMercaderia;
    }

    public String getObsTipoMercaderia() {
        return obsTipoMercaderia;
    }

    public void setObsTipoMercaderia(String obsTipoMercaderia) {
        this.obsTipoMercaderia = obsTipoMercaderia;
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
