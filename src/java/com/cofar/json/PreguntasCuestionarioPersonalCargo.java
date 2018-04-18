/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.json;

/**
 *
 * @author aquispe
 */
public class PreguntasCuestionarioPersonalCargo {
    private int codDocumento=0;
    private String respuestaAbierta="";
    private int preguntaCerrada=0;
    private int codPregunta=0;
    private RespuestasCuestionario[] respuestas=null;
    public PreguntasCuestionarioPersonalCargo() {
    }

    public int getCodDocumento() {
        return codDocumento;
    }

    public void setCodDocumento(int codDocumento) {
        this.codDocumento = codDocumento;
    }

    public int getCodPregunta() {
        return codPregunta;
    }

    public void setCodPregunta(int codPregunta) {
        this.codPregunta = codPregunta;
    }

    public int getPreguntaCerrada() {
        return preguntaCerrada;
    }

    public void setPreguntaCerrada(int preguntaCerrada) {
        this.preguntaCerrada = preguntaCerrada;
    }

    public String getRespuestaAbierta() {
        return respuestaAbierta;
    }

    public void setRespuestaAbierta(String respuestaAbierta) {
        this.respuestaAbierta = respuestaAbierta;
    }

    public RespuestasCuestionario[] getRespuestas() {
        return respuestas;
    }

    public void setRespuestas(RespuestasCuestionario[] respuestas) {
        this.respuestas = respuestas;
    }

    

}
