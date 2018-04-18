/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.util;

/**
 *
 * @author Ismael Juchazara
 */
public class BeneficioFiniquito {

    private Double desahucio;
    private Integer indemnizacionAnio;
    private Double indemnizacionAnioMonto;
    private Integer indemnizacionMes;
    private Double indemnizacionMesMonto;
    private Integer indemnizacionDia;
    private Double indemnizacionDiaMonto;
    private Double indemnizacionTotal;
    private Integer aguinaldoMes;
    private Integer aguinaldoDia;
    private Double aguinaldoTotal;
    private Integer vacacionMes;
    private Double vacacionDia;
    private Double vacacionTotal;
    private Integer primaMes;
    private Integer primaDia;
    private Double primaTotal;
    private Double totalBeneficios;
    private Double ivaVacacion;
    private Double deudaPendiente;
    private Double renuncia;
    private Double totalDeduccion;

    public BeneficioFiniquito(Double desahucio, Integer indemnizacionAnio, Double indemnizacionAnioMonto, Integer indemnizacionMes, Double indemnizacionMesMonto, Integer indemnizacionDia, Double indemnizacionDiaMonto, Double indemnizacionTotal, Integer aguinaldoMes, Integer aguinaldoDia, Double aguinaldoTotal, Integer vacacionMes, Double vacacionDia, Double vacacionTotal, Integer primaMes, Integer primaDia, Double primaTotal, Double ivaVacacion, Double deudaPendiente, Double renuncia) {
        this.desahucio = desahucio;
        this.indemnizacionAnio = indemnizacionAnio;
        this.indemnizacionAnioMonto = indemnizacionAnioMonto;
        this.indemnizacionMes = indemnizacionMes;
        this.indemnizacionMesMonto = indemnizacionMesMonto;
        this.indemnizacionDia = indemnizacionDia;
        this.indemnizacionDiaMonto = indemnizacionDiaMonto;
        this.indemnizacionTotal = indemnizacionTotal;
        this.aguinaldoMes = aguinaldoMes;
        this.aguinaldoDia = aguinaldoDia;
        this.aguinaldoTotal = aguinaldoTotal;
        this.vacacionMes = vacacionMes;
        this.vacacionDia = vacacionDia;
        this.vacacionTotal = vacacionTotal;
        this.primaMes = primaMes;
        this.primaDia = primaDia;
        this.primaTotal = primaTotal;
        this.ivaVacacion = ivaVacacion;
        this.deudaPendiente = deudaPendiente;
        this.renuncia = renuncia;
        this.totalBeneficios = this.desahucio + this.indemnizacionTotal + this.aguinaldoTotal + this.vacacionTotal + this.primaTotal;
        this.totalDeduccion = this.ivaVacacion + this.deudaPendiente + this.renuncia;
    }

    /*public BeneficioFiniquito(Double desahucio, Integer indemnizacionAnio, Double indemnizacionAnioMonto, Integer indemnizacionMes, Double indemnizacionMesMonto, Integer indemnizacionDia, Double indemnizacionDiaMonto, Double indemnizacionTotal, Integer aguinaldoMes, Integer aguinaldoDia, Double aguinaldoTotal, Integer vacacionMes, Integer vacacionDia, Double vacacionTotal, Integer primaMes, Integer primaDia, Double primaTotal, Double ivaVacacion, Double deudaPendiente, Double renuncia, Double totalDeduccion) {
        this.desahucio = desahucio;
        this.indemnizacionAnio = indemnizacionAnio;
        this.indemnizacionAnioMonto = indemnizacionAnioMonto;
        this.indemnizacionMes = indemnizacionMes;
        this.indemnizacionMesMonto = indemnizacionMesMonto;
        this.indemnizacionDia = indemnizacionDia;
        this.indemnizacionDiaMonto = indemnizacionDiaMonto;
        this.indemnizacionTotal = indemnizacionTotal;
        this.aguinaldoMes = aguinaldoMes;
        this.aguinaldoDia = aguinaldoDia;
        this.aguinaldoTotal = aguinaldoTotal;
        this.vacacionMes = vacacionMes;
        this.vacacionDia = vacacionDia;
        this.vacacionTotal = vacacionTotal;
        this.primaMes = primaMes;
        this.primaDia = primaDia;
        this.primaTotal = primaTotal;
        this.ivaVacacion = ivaVacacion;
        this.deudaPendiente = deudaPendiente;
        this.renuncia = renuncia;
        this.totalDeduccion = totalDeduccion;
    }*/

    /**
     * @return the desahucio
     */
    public Double getDesahucio() {
        return desahucio;
    }

    /**
     * @param desahucio the desahucio to set
     */
    public void setDesahucio(Double desahucio) {
        this.desahucio = desahucio;
    }

    /**
     * @return the indemnizacionAnio
     */
    public Integer getIndemnizacionAnio() {
        return indemnizacionAnio;
    }

    /**
     * @param indemnizacionAnio the indemnizacionAnio to set
     */
    public void setIndemnizacionAnio(Integer indemnizacionAnio) {
        this.indemnizacionAnio = indemnizacionAnio;
    }

    /**
     * @return the indemnizacionAnioMonto
     */
    public Double getIndemnizacionAnioMonto() {
        return indemnizacionAnioMonto;
    }

    /**
     * @param indemnizacionAnioMonto the indemnizacionAnioMonto to set
     */
    public void setIndemnizacionAnioMonto(Double indemnizacionAnioMonto) {
        this.indemnizacionAnioMonto = indemnizacionAnioMonto;
    }

    /**
     * @return the indemnizacionMes
     */
    public Integer getIndemnizacionMes() {
        return indemnizacionMes;
    }

    /**
     * @param indemnizacionMes the indemnizacionMes to set
     */
    public void setIndemnizacionMes(Integer indemnizacionMes) {
        this.indemnizacionMes = indemnizacionMes;
    }

    /**
     * @return the indemnizacionMesMonto
     */
    public Double getIndemnizacionMesMonto() {
        return indemnizacionMesMonto;
    }

    /**
     * @param indemnizacionMesMonto the indemnizacionMesMonto to set
     */
    public void setIndemnizacionMesMonto(Double indemnizacionMesMonto) {
        this.indemnizacionMesMonto = indemnizacionMesMonto;
    }

    /**
     * @return the indemnizacionDia
     */
    public Integer getIndemnizacionDia() {
        return indemnizacionDia;
    }

    /**
     * @param indemnizacionDia the indemnizacionDia to set
     */
    public void setIndemnizacionDia(Integer indemnizacionDia) {
        this.indemnizacionDia = indemnizacionDia;
    }

    /**
     * @return the indemnizacionDiaMonto
     */
    public Double getIndemnizacionDiaMonto() {
        return indemnizacionDiaMonto;
    }

    /**
     * @param indemnizacionDiaMonto the indemnizacionDiaMonto to set
     */
    public void setIndemnizacionDiaMonto(Double indemnizacionDiaMonto) {
        this.indemnizacionDiaMonto = indemnizacionDiaMonto;
    }

    /**
     * @return the indemnizacionTotal
     */
    public Double getIndemnizacionTotal() {
        return indemnizacionTotal;
    }

    /**
     * @param indemnizacionTotal the indemnizacionTotal to set
     */
    public void setIndemnizacionTotal(Double indemnizacionTotal) {
        this.indemnizacionTotal = indemnizacionTotal;
    }

    /**
     * @return the aguinaldoMes
     */
    public Integer getAguinaldoMes() {
        return aguinaldoMes;
    }

    /**
     * @param aguinaldoMes the aguinaldoMes to set
     */
    public void setAguinaldoMes(Integer aguinaldoMes) {
        this.aguinaldoMes = aguinaldoMes;
    }

    /**
     * @return the aguinaldoDia
     */
    public Integer getAguinaldoDia() {
        return aguinaldoDia;
    }

    /**
     * @param aguinaldoDia the aguinaldoDia to set
     */
    public void setAguinaldoDia(Integer aguinaldoDia) {
        this.aguinaldoDia = aguinaldoDia;
    }

    /**
     * @return the aguinaldoTotal
     */
    public Double getAguinaldoTotal() {
        return aguinaldoTotal;
    }

    /**
     * @param aguinaldoTotal the aguinaldoTotal to set
     */
    public void setAguinaldoTotal(Double aguinaldoTotal) {
        this.aguinaldoTotal = aguinaldoTotal;
    }

    /**
     * @return the vacacionMes
     */
    public Integer getVacacionMes() {
        return vacacionMes;
    }

    /**
     * @param vacacionMes the vacacionMes to set
     */
    public void setVacacionMes(Integer vacacionMes) {
        this.vacacionMes = vacacionMes;
    }

    /**
     * @return the vacacionDia
     */
    public Double getVacacionDia() {
        return vacacionDia;
    }

    /**
     * @param vacacionDia the vacacionDia to set
     */
    public void setVacacionDia(Double vacacionDia) {
        this.vacacionDia = vacacionDia;
    }

    /**
     * @return the vacacionTotal
     */
    public Double getVacacionTotal() {
        return vacacionTotal;
    }

    /**
     * @param vacacionTotal the vacacionTotal to set
     */
    public void setVacacionTotal(Double vacacionTotal) {
        this.vacacionTotal = vacacionTotal;
    }

    /**
     * @return the primaMes
     */
    public Integer getPrimaMes() {
        return primaMes;
    }

    /**
     * @param primaMes the primaMes to set
     */
    public void setPrimaMes(Integer primaMes) {
        this.primaMes = primaMes;
    }

    /**
     * @return the primaDia
     */
    public Integer getPrimaDia() {
        return primaDia;
    }

    /**
     * @param primaDia the primaDia to set
     */
    public void setPrimaDia(Integer primaDia) {
        this.primaDia = primaDia;
    }

    /**
     * @return the primaTotal
     */
    public Double getPrimaTotal() {
        return primaTotal;
    }

    /**
     * @param primaTotal the primaTotal to set
     */
    public void setPrimaTotal(Double primaTotal) {
        this.primaTotal = primaTotal;
    }

    /**
     * @return the ivaVacacion
     */
    public Double getIvaVacacion() {
        return ivaVacacion;
    }

    /**
     * @param ivaVacacion the ivaVacacion to set
     */
    public void setIvaVacacion(Double ivaVacacion) {
        this.ivaVacacion = ivaVacacion;
    }

    /**
     * @return the deudaPendiente
     */
    public Double getDeudaPendiente() {
        return deudaPendiente;
    }

    /**
     * @param deudaPendiente the deudaPendiente to set
     */
    public void setDeudaPendiente(Double deudaPendiente) {
        this.deudaPendiente = deudaPendiente;
    }

    /**
     * @return the renuncia
     */
    public Double getRenuncia() {
        return renuncia;
    }

    /**
     * @param renuncia the renuncia to set
     */
    public void setRenuncia(Double renuncia) {
        this.renuncia = renuncia;
    }

    /**
     * @return the totalDeduccion
     */
    public Double getTotalDeduccion() {
        return totalDeduccion;
    }

    /**
     * @param totalDeduccion the totalDeduccion to set
     */
    public void setTotalDeduccion(Double totalDeduccion) {
        this.totalDeduccion = totalDeduccion;
    }

    /**
     * @return the totalBeneficios
     */
    public Double getTotalBeneficios() {
        return totalBeneficios;
    }

    /**
     * @param totalBeneficios the totalBeneficios to set
     */
    public void setTotalBeneficios(Double totalBeneficios) {
        this.totalBeneficios = totalBeneficios;
    }
}
