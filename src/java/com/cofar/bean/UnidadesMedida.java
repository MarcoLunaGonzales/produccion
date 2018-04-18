/*
 * Personal.java
 *
 * Created on 6 de marzo de 2008, 11:15
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Gabriela Quelali Siñani
 * @company COFAR
 */
public class UnidadesMedida extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */

   
   private String  codUnidadMedida="";
   private String  codTipoMedida="";
   private String  nombreUnidadMedida="";
   private String  obsUnidadMedida="";
   private String  abreviatura="";
   private String  unidadClave="";
   private TiposMedida tipoMedida=new TiposMedida ();
   private EstadoReferencial estadoReferencial=new EstadoReferencial ();
  

    public UnidadesMedida() {
        
    }

    public String getCodUnidadMedida() {
        return codUnidadMedida;
    }

    public void setCodUnidadMedida(String codUnidadMedida) {
        this.codUnidadMedida = codUnidadMedida;
    }

    public String getCodTipoMedida() {
        return codTipoMedida;
    }

    public void setCodTipoMedida(String codTipoMedida) {
        this.codTipoMedida = codTipoMedida;
    }

    public String getNombreUnidadMedida() {
        return nombreUnidadMedida;
    }

    public void setNombreUnidadMedida(String nombreUnidadMedida) {
        this.nombreUnidadMedida = nombreUnidadMedida;
    }

    public String getObsUnidadMedida() {
        return obsUnidadMedida;
    }

    public void setObsUnidadMedida(String obsUnidadMedida) {
        this.obsUnidadMedida = obsUnidadMedida;
    }

    public String getAbreviatura() {
        return abreviatura;
    }

    public void setAbreviatura(String abreviatura) {
        this.abreviatura = abreviatura;
    }

    public String getUnidadClave() {
        return unidadClave;
    }

    public void setUnidadClave(String unidadClave) {
        this.unidadClave = unidadClave;
    }

    public TiposMedida getTipoMedida() {
        return tipoMedida;
    }

    public void setTipoMedida(TiposMedida tipoMedida) {
        this.tipoMedida = tipoMedida;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

   
    
}
