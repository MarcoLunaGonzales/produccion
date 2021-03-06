<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <script>
                function validar(){
               
                   var nombre=document.getElementById('form1:nombre');
                   var alto=document.getElementById('form1:alto');
                   var largo=document.getElementById('form1:largo');
                   var ancho=document.getElementById('form1:ancho');
                   var peso=document.getElementById('form1:peso');
                   var obs=document.getElementById('form1:obs');
                
                   if(nombre.value==''){
                     alert('El Campo Cart�n Corrugado esta vac�o.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensi�n Alto esta vac�o.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensi�n Largo esta vac�o.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensi�n Ancho esta vac�o.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vac�o.');
                     peso.focus();
                     return false;
                   }
                   if(obs.value==''){
                     alert('El Campo Descripci�n esta vac�o.');
                     obs.focus();
                     return false;
                   }
                                   
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >
                <h:outputText value="#{ManagedActividadesProduccion.codigoActividadesProduccion}" styleClass="outputText2" />
                <div align="center">
                    <br>
                    <h:outputText value="Registrar Actividad Producci�n" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                        </f:facet>
                        <h:outputText value="Actividad Producci�n" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedActividadesProduccion.actividadesProduccionbean.nombreActividad}" onkeypress="valMAY();" id="nombre" /> 
                        
                        <h:outputText value="Descripci�n" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedActividadesProduccion.actividadesProduccionbean.obsActividad}" id="obs"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />                                                
                        <h:outputText  styleClass="outputText2" value="::"/>                                
                        <h:inputText  styleClass="inputText" size="50" disabled="true" value="A C T I V O"/>                                
                        
                        <h:outputText value="Tipo Actividad " styleClass="outputText2"/>
                        <h:outputText  styleClass="outputText2" value="::"/>
                        <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionbean.tiposActividadProduccion.codTipoActividadProduccion}" styleClass="inputText">
                            <f:selectItems value="#{ManagedActividadesProduccion.tiposActividadProduccionList}"  />
                        </h:selectOneMenu>
                        <%--inicio ale unidades medida--%>
                        <h:outputText value="Unidad Medida" styleClass="outputText2" rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}"/>
                        <h:outputText  styleClass="outputText2" value="::" rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}"/>
                        <h:selectOneMenu value="#{ManagedActividadesProduccion.actividadesProduccionbean.unidadesMedida.codUnidadMedida}" styleClass="inputText" rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}">
                            <f:selectItems value="#{ManagedActividadesProduccion.unidadesMedidaList}"  />
                        </h:selectOneMenu>
                        <%--final ale unidades medida--%>
                        
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedActividadesProduccion.guardarActividadesProduccion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedActividadesProduccion.Cancelar}"/>
                </div>
                
            </h:form>
        </body>
    </html>
    
</f:view>

