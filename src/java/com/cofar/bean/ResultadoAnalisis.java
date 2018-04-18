/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;

/**
 *
 * @author wchoquehuanca
 */
public class ResultadoAnalisis  extends AbstractBean{

    private String codLote="";
    private ComponentesProd componenteProd= new ComponentesProd();
    private String NroAnalisis="";
    private int codAnalisis=0;
    private Personal PersonalAnalista=new Personal();
    private EstadosResultadoAnalisis estadoResultadoAnalisis=new EstadosResultadoAnalisis();
    private String tomo="";
    private String pagina="";
    private String nroAnalisisMicrobiologico="";
    private Date fechaRevision=new Date();
    private Date fechaEmision=new Date();
    private VersionEspecificacionesProducto versionEspecificacionFisica=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionEspecificacionQuimica=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionEspecificacionMicrobiologica=new VersionEspecificacionesProducto();
    private VersionEspecificacionesProducto versionConcentracionProducto=new VersionEspecificacionesProducto();

    public ResultadoAnalisis() {
    }

    public String getNroAnalisis() {
        return NroAnalisis;
    }

    public void setNroAnalisis(String NroAnalisis) {
        this.NroAnalisis = NroAnalisis;
    }

    public Personal getPersonalAnalista() {
        return PersonalAnalista;
    }

    public void setPersonalAnalista(Personal PersonalAnalista) {
        this.PersonalAnalista = PersonalAnalista;
    }

    public int getCodAnalisis() {
        return codAnalisis;
    }

    public void setCodAnalisis(int codAnalisis) {
        this.codAnalisis = codAnalisis;
    }

    public String getCodLote() {
        return codLote;
    }

    public void setCodLote(String codLote) {
        this.codLote = codLote;
    }

    public ComponentesProd getComponenteProd() {
        return componenteProd;
    }

    public void setComponenteProd(ComponentesProd componenteProd) {
        this.componenteProd = componenteProd;
    }

    public EstadosResultadoAnalisis getEstadoResultadoAnalisis() {
        return estadoResultadoAnalisis;
    }

    public void setEstadoResultadoAnalisis(EstadosResultadoAnalisis estadoResultadoAnalisis) {
        this.estadoResultadoAnalisis = estadoResultadoAnalisis;
    }

    public String getPagina() {
        return pagina;
    }

    public void setPagina(String pagina) {
        this.pagina = pagina;
    }

    public String getTomo() {
        return tomo;
    }

    public void setTomo(String tomo) {
        this.tomo = tomo;
    }

    public String getNroAnalisisMicrobiologico() {
        return nroAnalisisMicrobiologico;
    }

    public void setNroAnalisisMicrobiologico(String nroAnalisisMicrobiologico) {
        this.nroAnalisisMicrobiologico = nroAnalisisMicrobiologico;
    }

    public Date getFechaEmision() {
        return fechaEmision;
    }

    public void setFechaEmision(Date fechaEmision) {
        this.fechaEmision = fechaEmision;
    }

    public Date getFechaRevision() {
        return fechaRevision;
    }

    public void setFechaRevision(Date fechaRevision) {
        this.fechaRevision = fechaRevision;
    }

    public VersionEspecificacionesProducto getVersionConcentracionProducto() {
        return versionConcentracionProducto;
    }

    public void setVersionConcentracionProducto(VersionEspecificacionesProducto versionConcentracionProducto) {
        this.versionConcentracionProducto = versionConcentracionProducto;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionFisica() {
        return versionEspecificacionFisica;
    }

    public void setVersionEspecificacionFisica(VersionEspecificacionesProducto versionEspecificacionFisica) {
        this.versionEspecificacionFisica = versionEspecificacionFisica;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionMicrobiologica() {
        return versionEspecificacionMicrobiologica;
    }

    public void setVersionEspecificacionMicrobiologica(VersionEspecificacionesProducto versionEspecificacionMicrobiologica) {
        this.versionEspecificacionMicrobiologica = versionEspecificacionMicrobiologica;
    }

    public VersionEspecificacionesProducto getVersionEspecificacionQuimica() {
        return versionEspecificacionQuimica;
    }

    public void setVersionEspecificacionQuimica(VersionEspecificacionesProducto versionEspecificacionQuimica) {
        this.versionEspecificacionQuimica = versionEspecificacionQuimica;
    }

    

}
