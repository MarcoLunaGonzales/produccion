/*
 * EnvasesSecundarios.java
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
public class SolicitudMantenimiento extends AbstractBean{
    
    /** Creates a new instance of TiposMercaderia */
    private int codSolicitudMantenimiento=0;
    private Date fechaSolicitudMantenimiento=new Date();
    private Date fechaCambioEstadoSolicitud=new Date();
    private String obsSolicitudMantenimiento="";
    private boolean solicitudMantenimientoMaquinaria=false;//variable para saber si la solicitud va ser de maquina o instalacion
    private EstadoSolicitudMantenimiento estadoSolicitudMantenimiento=new EstadoSolicitudMantenimiento();
    private Gestiones gestiones=new Gestiones();
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private Personal personal_usuario=new Personal();
    private Personal personal_ejecutante=new Personal();
    private TiposSolicitudMantenimiento tiposSolicitudMantenimiento=new TiposSolicitudMantenimiento();
    private Maquinaria maquinaria=new Maquinaria();
    private String linkTipoOrdenDeTrabajo;
    private String linkTrabajosRealizar;
    private String linkMaterialesUtilizar;
    private String linkTiempoRealTrabajo;
    private String estilo="";
    private Date fechaAprobacion = new Date();
    private SolicitudesSalida solicitudesSalida = new SolicitudesSalida();
    private SolicitudesCompra solicitudesCompra = new SolicitudesCompra();
    int nroOrdenTrabajo = 0;
    int afectaraProduccion = 0;
    AreasInstalaciones areasInstalaciones = new AreasInstalaciones();
    PartesMaquinaria partesMaquinaria = new PartesMaquinaria();
    AreasInstalacionesModulos areasInstalacionesModulos = new AreasInstalacionesModulos();
    TiposNivelSolicitudMantenimiento tiposNivelSolicitudMantenimiento = new TiposNivelSolicitudMantenimiento();
    ModulosInstalaciones modulosInstalaciones = new ModulosInstalaciones();
    String descripcionEstado = "";
    private AreasInstalacionesDetalle areasInstalacionesDetalle=new AreasInstalacionesDetalle();
    private int solicitudProyecto = 0;
    private int solicitudProduccion = 0;

    public int getCodSolicitudMantenimiento() {
        return codSolicitudMantenimiento;
    }

    public void setCodSolicitudMantenimiento(int codSolicitudMantenimiento) {
        this.codSolicitudMantenimiento = codSolicitudMantenimiento;
    }

    

    public Date getFechaCambioEstadoSolicitud() {
        return fechaCambioEstadoSolicitud;
    }

    public void setFechaCambioEstadoSolicitud(Date fechaCambioEstadoSolicitud) {
        this.fechaCambioEstadoSolicitud = fechaCambioEstadoSolicitud;
    }

    public Date getFechaSolicitudMantenimiento() {
        return fechaSolicitudMantenimiento;
    }

    public void setFechaSolicitudMantenimiento(Date fechaSolicitudMantenimiento) {
        this.fechaSolicitudMantenimiento = fechaSolicitudMantenimiento;
    }

    public EstadoSolicitudMantenimiento getEstadoSolicitudMantenimiento() {
        return estadoSolicitudMantenimiento;
    }

    public void setEstadoSolicitudMantenimiento(EstadoSolicitudMantenimiento estadoSolicitudMantenimiento) {
        this.estadoSolicitudMantenimiento = estadoSolicitudMantenimiento;
    }

    public Gestiones getGestiones() {
        return gestiones;
    }

    public void setGestiones(Gestiones gestiones) {
        this.gestiones = gestiones;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Personal getPersonal_usuario() {
        return personal_usuario;
    }

    public void setPersonal_usuario(Personal personal_usuario) {
        this.personal_usuario = personal_usuario;
    }

    public Personal getPersonal_ejecutante() {
        return personal_ejecutante;
    }

    public void setPersonal_ejecutante(Personal personal_ejecutante) {
        this.personal_ejecutante = personal_ejecutante;
    }

    public TiposSolicitudMantenimiento getTiposSolicitudMantenimiento() {
        return tiposSolicitudMantenimiento;
    }

    public void setTiposSolicitudMantenimiento(TiposSolicitudMantenimiento tiposSolicitudMantenimiento) {
        this.tiposSolicitudMantenimiento = tiposSolicitudMantenimiento;
    }

    public Maquinaria getMaquinaria() {
        return maquinaria;
    }

    public void setMaquinaria(Maquinaria maquinaria) {
        this.maquinaria = maquinaria;
    }

    public String getObsSolicitudMantenimiento() {
        return obsSolicitudMantenimiento;
    }

    public void setObsSolicitudMantenimiento(String obsSolicitudMantenimiento) {
        this.obsSolicitudMantenimiento = obsSolicitudMantenimiento;
    }


    public String getEstilo() {
        return estilo;
    }

    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }

    public String getLinkMaterialesUtilizar() {
        return linkMaterialesUtilizar;
    }

    public void setLinkMaterialesUtilizar(String linkMaterialesUtilizar) {
        this.linkMaterialesUtilizar = linkMaterialesUtilizar;
    }

    public String getLinkTipoOrdenDeTrabajo() {
        return linkTipoOrdenDeTrabajo;
    }

    public void setLinkTipoOrdenDeTrabajo(String linkTipoOrdenDeTrabajo) {
        this.linkTipoOrdenDeTrabajo = linkTipoOrdenDeTrabajo;
    }

    public String getLinkTrabajosRealizar() {
        return linkTrabajosRealizar;
    }

    public void setLinkTrabajosRealizar(String linkTrabajosRealizar) {
        this.linkTrabajosRealizar = linkTrabajosRealizar;
    }

    public String getLinkTiempoRealTrabajo() {
        return linkTiempoRealTrabajo;
    }

    public void setLinkTiempoRealTrabajo(String linkTiempoRealTrabajo) {
        this.linkTiempoRealTrabajo = linkTiempoRealTrabajo;
    }

    public Date getFechaAprobacion() {
        return fechaAprobacion;
    }

    public void setFechaAprobacion(Date fechaAprobacion) {
        this.fechaAprobacion = fechaAprobacion;
    }

    public SolicitudesSalida getSolicitudesSalida() {
        return solicitudesSalida;
    }

    public void setSolicitudesSalida(SolicitudesSalida solicitudesSalida) {
        this.solicitudesSalida = solicitudesSalida;
    }

    public SolicitudesCompra getSolicitudesCompra() {
        return solicitudesCompra;
    }

    public void setSolicitudesCompra(SolicitudesCompra solicitudesCompra) {
        this.solicitudesCompra = solicitudesCompra;
    }

    public int getNroOrdenTrabajo() {
        return nroOrdenTrabajo;
    }

    public void setNroOrdenTrabajo(int nroOrdenTrabajo) {
        this.nroOrdenTrabajo = nroOrdenTrabajo;
    }

    public int getAfectaraProduccion() {
        return afectaraProduccion;
    }

    public void setAfectaraProduccion(int afectaraProduccion) {
        this.afectaraProduccion = afectaraProduccion;
    }

    public AreasInstalaciones getAreasInstalaciones() {
        return areasInstalaciones;
    }

    public void setAreasInstalaciones(AreasInstalaciones areasInstalaciones) {
        this.areasInstalaciones = areasInstalaciones;
    }

    public PartesMaquinaria getPartesMaquinaria() {
        return partesMaquinaria;
    }

    public void setPartesMaquinaria(PartesMaquinaria partesMaquinaria) {
        this.partesMaquinaria = partesMaquinaria;
    }

    public AreasInstalacionesModulos getAreasInstalacionesModulos() {
        return areasInstalacionesModulos;
    }

    public void setAreasInstalacionesModulos(AreasInstalacionesModulos areasInstalacionesModulos) {
        this.areasInstalacionesModulos = areasInstalacionesModulos;
    }

    public TiposNivelSolicitudMantenimiento getTiposNivelSolicitudMantenimiento() {
        return tiposNivelSolicitudMantenimiento;
    }

    public void setTiposNivelSolicitudMantenimiento(TiposNivelSolicitudMantenimiento tiposNivelSolicitudMantenimiento) {
        this.tiposNivelSolicitudMantenimiento = tiposNivelSolicitudMantenimiento;
    }

    public ModulosInstalaciones getModulosInstalaciones() {
        return modulosInstalaciones;
    }

    public void setModulosInstalaciones(ModulosInstalaciones modulosInstalaciones) {
        this.modulosInstalaciones = modulosInstalaciones;
    }

    public String getDescripcionEstado() {
        return descripcionEstado;
    }

    public void setDescripcionEstado(String descripcionEstado) {
        this.descripcionEstado = descripcionEstado;
    }

    public AreasInstalacionesDetalle getAreasInstalacionesDetalle() {
        return areasInstalacionesDetalle;
    }

    public void setAreasInstalacionesDetalle(AreasInstalacionesDetalle areasInstalacionesDetalle) {
        this.areasInstalacionesDetalle = areasInstalacionesDetalle;
    }

    public int getSolicitudProduccion() {
        return solicitudProduccion;
    }

    public void setSolicitudProduccion(int solicitudProduccion) {
        this.solicitudProduccion = solicitudProduccion;
    }

    public int getSolicitudProyecto() {
        return solicitudProyecto;
    }

    public void setSolicitudProyecto(int solicitudProyecto) {
        this.solicitudProyecto = solicitudProyecto;
    }

    public boolean isSolicitudMantenimientoMaquinaria() {
        return solicitudMantenimientoMaquinaria;
    }

    public void setSolicitudMantenimientoMaquinaria(boolean solicitudMantenimientoMaquinaria) {
        this.solicitudMantenimientoMaquinaria = solicitudMantenimientoMaquinaria;
    }

     


    
}
