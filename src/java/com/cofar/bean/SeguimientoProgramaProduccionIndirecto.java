/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author wchoquehuanca
 */
public class SeguimientoProgramaProduccionIndirecto extends AbstractBean{
    private List<SeguimientoProgramaProduccionIndirectoPersonal> listaSeguimientoPersonal= new ArrayList<SeguimientoProgramaProduccionIndirectoPersonal>();
    private ProgramaProduccionPeriodo programaProduccionPeriodo= new ProgramaProduccionPeriodo();
    private  ActividadesProgramaProduccionIndirecto actividadesProgramaProduccionIndirecto= new ActividadesProgramaProduccionIndirecto();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private float  horasHombre=0;
    public SeguimientoProgramaProduccionIndirecto() {
    }



    public ActividadesProgramaProduccionIndirecto getActividadesProgramaProduccionIndirecto() {
        return actividadesProgramaProduccionIndirecto;
    }

    public void setActividadesProgramaProduccionIndirecto(ActividadesProgramaProduccionIndirecto actividadesProgramaProduccionIndirecto) {
        this.actividadesProgramaProduccionIndirecto = actividadesProgramaProduccionIndirecto;
    }

   

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public float getHorasHombre() {
        return horasHombre;
    }

    public void setHorasHombre(float horasHombre) {
        this.horasHombre = horasHombre;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public List<SeguimientoProgramaProduccionIndirectoPersonal> getListaSeguimientoPersonal() {
        return listaSeguimientoPersonal;
    }

    public void setListaSeguimientoPersonal(List<SeguimientoProgramaProduccionIndirectoPersonal> listaSeguimientoPersonal) {
        this.listaSeguimientoPersonal = listaSeguimientoPersonal;
    }

   
    

}
