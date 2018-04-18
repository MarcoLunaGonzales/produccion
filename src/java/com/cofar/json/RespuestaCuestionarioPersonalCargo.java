/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.json;

/**
 *
 * @author aquispe
 */

public class RespuestaCuestionarioPersonalCargo {
    private int codCuestionarioCargo=0;
    private int codPersonal=0;
    private int tiempoRegistro=0;
    private PreguntasCuestionarioPersonalCargo[] preguntas=null;
    private RespuestasCuestionarioPersonalCargoArgumento[] respuestasArgumentos=null;
    public RespuestaCuestionarioPersonalCargo() {
    }

    public int getCodCuestionarioCargo() {
        return codCuestionarioCargo;
    }

    public void setCodCuestionarioCargo(int codCuestionarioCargo) {
        this.codCuestionarioCargo = codCuestionarioCargo;
    }

    public int getCodPersonal() {
        return codPersonal;
    }

    public void setCodPersonal(int codPersonal) {
        this.codPersonal = codPersonal;
    }

    public int getTiempoRegistro() {
        return tiempoRegistro;
    }

    public void setTiempoRegistro(int tiempoRegistro) {
        this.tiempoRegistro = tiempoRegistro;
    }

    public PreguntasCuestionarioPersonalCargo[] getPreguntas() {
        return preguntas;
    }

    public void setPreguntas(PreguntasCuestionarioPersonalCargo[] preguntas) {
        this.preguntas = preguntas;
    }

    public RespuestasCuestionarioPersonalCargoArgumento[] getRespuestasArgumentos() {
        return respuestasArgumentos;
    }

    public void setRespuestasArgumentos(RespuestasCuestionarioPersonalCargoArgumento[] respuestasArgumentos) {
        this.respuestasArgumentos = respuestasArgumentos;
    }
    
}
