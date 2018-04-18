/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;



/**
 *
 * @author hvaldivia
 */
public class SolicitudMantenimientoDetalleTareas extends AbstractBean{
      SolicitudMantenimiento solicitudMantenimiento = new SolicitudMantenimiento();
      TiposTarea tiposTarea = new TiposTarea();
      String descripcion = "";
      Personal personal = new Personal();
      Date fechaInicial = new Date();
      Date fechaFinal = new Date();
      Proveedores proveedores = new Proveedores();      
      float horasHombre = 0;
      Boolean conSolicitudMantenimientoPreventiva = new Boolean(false);
      private Date horaInicial=new Date();
      private Date horaFinal=new Date();
      private int turno=0;
      private boolean terminado=false;
      private boolean repuestos=false;
      private float horasExtra=0;
      boolean registroHorasExtra=false;
      private boolean tareaPersonalExterno=false;
    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public Date getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(Date fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

  
    public Date getFechaInicial() {
        return fechaInicial;
    }

    public void setFechaInicial(Date fechaInicial) {
        this.fechaInicial = fechaInicial;
    }
    
    public float getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(float horasHombre) {
        this.horasHombre = horasHombre;
    }

    public Personal getPersonal() {
        return personal;
    }

    public void setPersonal(Personal personal) {
        this.personal = personal;
    }

    public Proveedores getProveedores() {
        return proveedores;
    }

    public void setProveedores(Proveedores proveedores) {
        this.proveedores = proveedores;
    }

    public SolicitudMantenimiento getSolicitudMantenimiento() {
        return solicitudMantenimiento;
    }

    public void setSolicitudMantenimiento(SolicitudMantenimiento solicitudMantenimiento) {
        this.solicitudMantenimiento = solicitudMantenimiento;
    }

    public TiposTarea getTiposTarea() {
        return tiposTarea;
    }

    public void setTiposTarea(TiposTarea tiposTarea) {
        this.tiposTarea = tiposTarea;
    }

    public Boolean getConSolicitudMantenimientoPreventiva() {
        return conSolicitudMantenimientoPreventiva;
    }

    public void setConSolicitudMantenimientoPreventiva(Boolean conSolicitudMantenimientoPreventiva) {
        this.conSolicitudMantenimientoPreventiva = conSolicitudMantenimientoPreventiva;
    }

    public Date getHoraFinal() {
        return horaFinal;
    }

    public void setHoraFinal(Date horaFinal) {
        this.horaFinal = horaFinal;
    }

    public Date getHoraInicial() {
        return horaInicial;
    }

    public void setHoraInicial(Date horaInicial) {
        this.horaInicial = horaInicial;
    }

    public float getHorasExtra() {
        return horasExtra;
    }

    public void setHorasExtra(float horasExtra) {
        this.horasExtra = horasExtra;
    }

    public boolean isRepuestos() {
        return repuestos;
    }

    public void setRepuestos(boolean repuestos) {
        this.repuestos = repuestos;
    }

    public boolean isTerminado() {
        return terminado;
    }

    public void setTerminado(boolean terminado) {
        this.terminado = terminado;
    }

    public int getTurno() {
        return turno;
    }

    public void setTurno(int turno) {
        this.turno = turno;
    }

    public boolean isRegistroHorasExtra() {
        return registroHorasExtra;
    }

    public void setRegistroHorasExtra(boolean registroHorasExtra) {
        this.registroHorasExtra = registroHorasExtra;
    }

    public boolean isTareaPersonalExterno() {
        return tareaPersonalExterno;
    }

    public void setTareaPersonalExterno(boolean tareaPersonalExterno) {
        this.tareaPersonalExterno = tareaPersonalExterno;
    }
    
    

    
}
