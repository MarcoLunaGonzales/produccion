<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<rich:modalPanel id="panelMensajeTransaccion" top="50"
                minHeight="155"  minWidth="310"
                height="155" width="310" zindex="200"
                headerClass="headerMessage"
                resizeable="true">
    <f:facet name="header">
        <h:outputText id="cabeceraMensajeTransaccion" value="<span id='cabeceraMensaje'>#{MensajeTransaccion.transaccionExitosa?'Transaccion Exitosa':'Transaccion Fallida'}</span>" escape="false" />
    </f:facet>
    <a4j:form id="formMensajeTransaccion">
        
        <a4j:jsFunction name="reRenderMensajeTransaccion"  reRender="formMensajeTransaccion,cabeceraMensajeTransaccion" />
        <h:outputText value="<div class='#{MensajeTransaccion.transaccionExitosa?'messageImageOk':'messageImageNotOk'}'></div><div style='float:left;width:14px;height:100px'/>&nbsp;</div><div class='bodyMessage' id='mensajeTransaccionSistema'><span>" escape="false"/>
        <h:outputText value="#{MensajeTransaccion.mensajeTransaccion}" id="mensajeTransaccion"/>
        <h:outputText value="</span></div>" escape="false"/>
        <h:outputText value="<div class='footerMessage'><a class='btn' onclick='#{MensajeTransaccion.transaccionExitosa?'eventoMensajeTransaccionExitosa()':'eventoMensajeTransaccionFallida()'}' id='bottonAceptarMensajeTransaccion'>Aceptar</a></div>" escape="false"/>
    </a4j:form>
    
</rich:modalPanel>