/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class MesFiniquito {

    private String nombreMes;
    private Double salario;
    private Double dominical;
    private Double reintegro;
    private Double comision;
    private Double extras;
    private Double nocturno;
    private Double antiguedad;
    private Double total;

    public MesFiniquito(String nombreMes, double salario, double dominical, double reintegro, double comision, double extras, double nocturno, double antiguedad) {
        this.nombreMes = nombreMes;
        this.salario = salario;
        this.dominical = dominical;
        this.reintegro = reintegro;
        this.comision = comision;
        this.extras = extras;
        this.nocturno = nocturno;
        this.antiguedad = antiguedad;
        this.total = salario + dominical + reintegro + comision + extras + nocturno + antiguedad;
    }

    /**
     * @return the nombreMes
     */
    public String getNombreMes() {
        return nombreMes;
    }

    /**
     * @param nombreMes the nombreMes to set
     */
    public void setNombreMes(String nombreMes) {
        this.nombreMes = nombreMes;
    }

    /**
     * @return the salario
     */
    public Double getSalario() {
        return salario;
    }

    /**
     * @param salario the salario to set
     */
    public void setSalario(Double salario) {
        this.salario = salario;
    }

    /**
     * @return the dominical
     */
    public Double getDominical() {
        return dominical;
    }

    /**
     * @param dominical the dominical to set
     */
    public void setDominical(Double dominical) {
        this.dominical = dominical;
    }

    /**
     * @return the reintegro
     */
    public Double getReintegro() {
        return reintegro;
    }

    /**
     * @param reintegro the reintegro to set
     */
    public void setReintegro(Double reintegro) {
        this.reintegro = reintegro;
    }

    /**
     * @return the comision
     */
    public Double getComision() {
        return comision;
    }

    /**
     * @param comision the comision to set
     */
    public void setComision(Double comision) {
        this.comision = comision;
    }

    /**
     * @return the extras
     */
    public Double getExtras() {
        return extras;
    }

    /**
     * @param extras the extras to set
     */
    public void setExtras(Double extras) {
        this.extras = extras;
    }

    /**
     * @return the nocturno
     */
    public Double getNocturno() {
        return nocturno;
    }

    /**
     * @param nocturno the nocturno to set
     */
    public void setNocturno(Double nocturno) {
        this.nocturno = nocturno;
    }

    /**
     * @return the antiguedad
     */
    public Double getAntiguedad() {
        return antiguedad;
    }

    /**
     * @param antiguedad the antiguedad to set
     */
    public void setAntiguedad(Double antiguedad) {
        this.antiguedad = antiguedad;
    }

     /**
     * @return the total
     */
    public Double getTotal() {
        return total;
    }

    /**
     * @param total the total to set
     */
    public void setTotal(Double total) {
        this.total = total;
    }
}
