/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar;

import javax.faces.application.FacesMessage;
import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.validator.Validator;
import javax.faces.validator.ValidatorException;

/**
 *
 * @author DASISAQ
 */
public class ValidatorDoubleRange implements Validator{

    @Override
    public void validate(FacesContext fc, UIComponent uic, Object o) throws ValidatorException {
        if(uic.getAttributes().get("disable") == null 
                || uic.getAttributes().get("disable").toString().equals("false"))
        {
            if(uic.getAttributes().get("maximum") != null && uic.getAttributes().get("minimum") != null)
            {
                try
                {
                    Double minimo = Double.valueOf(uic.getAttributes().get("minimum").toString());
                    Double maximo = Double.valueOf(uic.getAttributes().get("maximum").toString());
                    Double valor = Double.valueOf(o.toString());
                    if(valor > maximo || valor < minimo )
                    {
                        FacesMessage msg = new FacesMessage("Numero no valido",
                                                    "El numero debe encontrarse entre "+minimo+" y "+maximo);
                        msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                        throw new ValidatorException(msg);
                    }
                }
                catch(NumberFormatException ex)
                {
                    ex.printStackTrace();
                    FacesMessage msg = new FacesMessage("Error de sistema",
						"Intervalo de valores incorrecto, notifique a sistemas");
                    msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                    throw new ValidatorException(msg);
                }
            }
            else
            {
                if(uic.getAttributes().get("minimum") != null)
                {
                    try
                    {
                        Double minimo = Double.valueOf(uic.getAttributes().get("minimum").toString());
                        Double valor = Double.valueOf(o.toString());
                        if(valor < minimo )
                        {
                            FacesMessage msg = new FacesMessage("Numero no valido",
                                                        "El numero debe ser mayor o igual que "+minimo);
                            msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                            throw new ValidatorException(msg);
                        }
                    }
                    catch(NumberFormatException ex)
                    {
                        ex.printStackTrace();
                        FacesMessage msg = new FacesMessage("Error de sistema",
                                                    "Valor minimo incorrecto, notifique a sistemas");
                        msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                        throw new ValidatorException(msg);
                    }
                }
                if(uic.getAttributes().get("maximum") != null)
                {
                    try
                    {
                        Double maximo = Double.valueOf(uic.getAttributes().get("maximum").toString());
                        Double valor = Double.valueOf(o.toString());
                        if(valor > maximo )
                        {
                            FacesMessage msg = new FacesMessage("Numero no valido",
                                                        "El numero debe ser menor o igual que "+maximo);
                            msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                            throw new ValidatorException(msg);
                        }
                    }
                    catch(NumberFormatException ex)
                    {
                        ex.printStackTrace();
                        FacesMessage msg = new FacesMessage("Error de sistema",
                                                    "Valor maximo incorrecto, notifique a sistemas");
                        msg.setSeverity(FacesMessage.SEVERITY_ERROR);
                        throw new ValidatorException(msg);
                    }
                }
            }
        }
    }
    
    
}
