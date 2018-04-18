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
public class TiposMedida extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */

   private int codTipoMedida=0;
   private String cod_tipo_medida="";
   private String nombre_tipo_medida="";
   private String obs_tipo_medida="";
   private EstadoReferencial estadoReferencial=new EstadoReferencial ();
  

    public TiposMedida() {
        
    }

    public String getCod_tipo_medida() {
        return cod_tipo_medida;
    }

    public void setCod_tipo_medida(String cod_tipo_medida) {
        this.cod_tipo_medida = cod_tipo_medida;
    }

    public String getNombre_tipo_medida() {
        return nombre_tipo_medida;
    }

    public void setNombre_tipo_medida(String nombre_tipo_medida) {
        this.nombre_tipo_medida = nombre_tipo_medida;
    }

    public String getObs_tipo_medida() {
        return obs_tipo_medida;
    }

    public void setObs_tipo_medida(String obs_tipo_medida) {
        this.obs_tipo_medida = obs_tipo_medida;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public int getCodTipoMedida() {
        return codTipoMedida;
    }

    public void setCodTipoMedida(int codTipoMedida) {
        this.codTipoMedida = codTipoMedida;
    }

   
    
    
}
