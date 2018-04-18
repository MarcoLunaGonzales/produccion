/*
 * Personal.java
 *
 * Created on 6 de marzo de 2008, 11:15
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author Wilson Choquehuanca
 * @company COFAR
 */
public class TiposMantenimiento extends AbstractBean{
    /** Creates a new instance of EnvasesPrimarios */

   
   private int codTipoMantenimiento=0;
   private String nombreTipoMantenimiento="";
   private EstadoReferencial estadoReferencial=new EstadoReferencial ();

    public int getCodTipoMantenimiento() {
        return codTipoMantenimiento;
    }

    public void setCodTipoMantenimiento(int codTipoMantenimiento) {
        this.codTipoMantenimiento = codTipoMantenimiento;
    }
    
    public String getNombreTipoMantenimiento() {
        return nombreTipoMantenimiento;
    }

    public void setNombreTipoMantenimiento(String nombreTipoMantenimiento) {
        this.nombreTipoMantenimiento = nombreTipoMantenimiento;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

}
