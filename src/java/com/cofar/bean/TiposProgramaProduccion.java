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
public class TiposProgramaProduccion implements Cloneable {
    
    /** Creates a new instance of TiposMercaderia */
    private String codTipoProgramaProd="0";
    private String nombreProgramaProd="";
    private String obsProgramaProd="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial ();
    private Boolean checked=new Boolean (false);
    private String nombreTipoProgramaProd = "";

    public String getCodTipoProgramaProd() {
        return codTipoProgramaProd;
    }

    public void setCodTipoProgramaProd(String codTipoProgramaProd) {
        this.codTipoProgramaProd = codTipoProgramaProd;
    }

    public String getNombreProgramaProd() {
        return nombreProgramaProd;
    }

    public void setNombreProgramaProd(String nombreProgramaProd) {
        this.nombreProgramaProd = nombreProgramaProd;
    }

    public String getObsProgramaProd() {
        return obsProgramaProd;
    }

    public void setObsProgramaProd(String obsProgramaProd) {
        this.obsProgramaProd = obsProgramaProd;
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

    public String getNombreTipoProgramaProd() {
        return nombreTipoProgramaProd;
    }

    public void setNombreTipoProgramaProd(String nombreTipoProgramaProd) {
        this.nombreTipoProgramaProd = nombreTipoProgramaProd;
    }

    public Object clone()
    {
        Object obj=null;
        try
        {
            obj=super.clone();
        }
        catch(CloneNotSupportedException ex)
        {
            ex.printStackTrace();
            System.out.println("no se puede clonar");
        }
        
        return obj;
    }

  
}
