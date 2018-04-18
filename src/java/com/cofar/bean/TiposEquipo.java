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
public class TiposEquipo extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */

   
   private String codTipoEquipo="";
   private String nombreTipoEquipo="";
   private EstadoReferencial estadoReferencial=new EstadoReferencial ();

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

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }
  

}
