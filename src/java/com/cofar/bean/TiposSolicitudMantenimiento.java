// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   TiposSolicitudMantenimiento.java

package com.cofar.bean;


// Referenced classes of package com.cofar.bean:
//            AbstractBean, EstadoReferencial

public class TiposSolicitudMantenimiento extends AbstractBean
{
    private int codTipoSolicitud=0;
    private String nombreTipoSolicitud="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public TiposSolicitudMantenimiento() {
    }

    public int getCodTipoSolicitud() {
        return codTipoSolicitud;
    }

    public void setCodTipoSolicitud(int codTipoSolicitud) {
        this.codTipoSolicitud = codTipoSolicitud;
    }

    public String getNombreTipoSolicitud() {
        return nombreTipoSolicitud;
    }

    public void setNombreTipoSolicitud(String nombreTipoSolicitud) {
        this.nombreTipoSolicitud = nombreTipoSolicitud;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }
    
}
