/*
 * Personal.java
 *
 * Created on 6 de marzo de 2008, 11:15
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Gabriela Quelali
 * @company COFAR
 */
public class FormasFarmaceuticas extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */

   private String codForma="";
   private String nombreForma="";
   private String abreviaturaForma="";
   private String obsForma="";
   private UnidadesMedida unidadMedida=new UnidadesMedida();
   private EstadoReferencial estadoReferencial=new EstadoReferencial ();
  
    public FormasFarmaceuticas() {
        
    }

    public String getCodForma() {
        return codForma;
    }

    public void setCodForma(String codForma) {
        this.codForma = codForma;
    }

    public String getNombreForma() {
        return nombreForma;
    }

    public void setNombreForma(String nombreForma) {
        this.nombreForma = nombreForma;
    }

    public String getAbreviaturaForma() {
        return abreviaturaForma;
    }

    public void setAbreviaturaForma(String abreviaturaForma) {
        this.abreviaturaForma = abreviaturaForma;
    }

    public String getObsForma() {
        return obsForma;
    }

    public void setObsForma(String obsForma) {
        this.obsForma = obsForma;
    }

    public UnidadesMedida getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(UnidadesMedida unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
  
    
}
