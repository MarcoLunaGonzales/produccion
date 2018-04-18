<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>

<html>
    <head>
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script>
    function validar(){
       var nombreareaempresa=document.getElementById('form1:nombreareaempresa');
       var obsareaempresa=document.getElementById('form1:obsareaempresa');
       if(nombreareaempresa.value==''){
         alert('Por favor instroduzca Nombre Area Empresa');
         nombreareaempresa.focus();
         return false;
       }
       /*if(obsareaempresa.value==''){
         alert('Por favor instroduzca datos');
         obsareaempresa.focus();
         return false;
       } */                  
       return true;
    }
        </script>
    </head>
    <body>
        <f:view>
            <h:form id="form1">
                <center>
                    <br><b><h:outputText value="Solicitud de Pedido de Materiales" styleClass="tituloCabezera1"/></b>            
                    <h:outputText value="#{ManagedSolMantenimiento.obtenerCodigo}"  />
                    <br><br>
                    <h:outputText value = "Fecha" styleClass="outputText2"  />
                    <h:outputText value = ":: " styleClass="outputText2" />
                   
                    <h:panelGroup>
                        <h:inputText value="#{ManagedSolMantenimiento.accionesMaterialesbean.fechaPedidoSolicitud}"   styleClass="outputTextNormal"  id="ordenSolFecha"  size="15" onblur="valFecha(this);" >
                            <f:convertDateTime pattern="dd/MM/yyyy"   />
                        </h:inputText>
                        <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha1" />
                        <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:ordenSolFecha\" click_element_id=\"form1:imagenFecha1\"></DLCALENDAR>"  escape="false"  />                                                        
                    </h:panelGroup>
                    
                    
                    <br><br>
                    
                    <h:outputText value="Estado" styleClass="outputText2"  />
                    <h:outputText value="::" styleClass="outputText2"   /> 
                    <h:outputText value="#{ManagedSolMantenimiento.accionesMaterialesbean.estado}" styleClass="outputText" />                 
                    
                    <br><br><br>
                    
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Introduzca los Datos" styleClass="outputText2"  />
                        </f:facet>
                        <h:outputText value="Material" styleClass="outputText2" />
                        <h:outputText value="::" styleClass="outputText2"   />                 
                        
                        <h:selectOneMenu value="#{ManagedSolMantenimiento.ordenSolicitudMantenimientobean.ordenCodMaterial}" id="codMaterial">
                            <f:selectItems value="#{ManagedSolMantenimiento.estadosOrdenMantenimientoList}" />                       
                        </h:selectOneMenu>    
                        
                        
                        <h:outputText value="Cantidad" styleClass="outputText2"  />
                        <h:outputText value="::" styleClass="outputText2"   /> 
                        <h:inputText  styleClass="inputText" size="20" value="#{ManagedSolMantenimiento.accionesMaterialesbean.cantidadSolicitada}" id="ordenSolCantidad" />  
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar"  styleClass="btn" action="#{ManagedSolMantenimiento.guardarOrdenPedido}" />
                    <h:commandButton value="Cancelar" styleClass="btn" action="#{ManagedSolMantenimiento.Cancelar}"/>
                    <br><br><br><br>
                    
                    <rich:dataTable value="#{ManagedSolMantenimiento.pedidoMaterialesList}" var="data" id="dataFormula2" onRowMouseOut="this.style.backgroundColor='#FFFFFF';"                  
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" headerClass="headerClassACliente">                                      
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nro." />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.nroOrden}" />
                        </rich:column>
                        
                        <rich:column>    
                            <f:facet name="header">
                                <h:outputText value="Materiales"  />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.materialesBean.nombreMaterial}" /> 
                        </rich:column>
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad a Solicitar"  />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.cantidadSolicitada}" />
                        </rich:column>
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad en Stock"  />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.cantidadStock}" />
                        </rich:column>       
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Diferencia"  />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.diferencia}"/>
                        </rich:column>
                        
                        <rich:column>
                            
                            <f:facet name="header">
                                <h:outputText value="fecha de Solicitud"  />
                            </f:facet>
                            <h:outputText styleClass="outputText2" value="#{data.fechaPedidoSolicitud}"/>
                            
                            
                        </rich:column>                        
                    </rich:dataTable> 
                    <br><br> 
                    <h:commandButton value="Enviar Solicitud de Compra"   styleClass="btn"  action="#{ManagedSolMantenimiento.ordenCompraMantenimiento}" />
                    <h:commandButton value="Enviar Solicitud de Salida"   styleClass="btn"  action="#{ManagedSolMantenimiento.ordenSalidaMantenimiento}" />
                </center>
            </h:form> 
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </f:view>
    </body>
</html>