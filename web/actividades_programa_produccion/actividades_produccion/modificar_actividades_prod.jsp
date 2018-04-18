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
                   
                
                   if(nombre.value==''){
                     alert('El Campo Cartón Corrugado esta vacío.');
                     nombre.focus();
                     return false;
                   }
                   if(alto.value==''){
                     alert('El Campo Dimensión Alto esta vacío.');
                     alto.focus();
                     return false;
                   }
                   if(largo.value==''){
                     alert('El Campo Dimensión Largo esta vacío.');
                     largo.focus();
                     return false;
                   }
                   if(ancho.value==''){
                     alert('El Campo Dimensión Ancho esta vacío.');
                     ancho.focus();
                     return false;
                   }
                   if(peso.value==''){
                     alert('El Campo Peso Gramos esta vacío.');
                     peso.focus();
                     return false;
                   }
                
                                   
                   return true;
                }
            </script>
        </head>
        <body>
            <br><br>
            <h:form id="form1"  >                
                <div align="center">
                    <br>
                    <h:outputText value="Editar Actividad Producción" styleClass="tituloCabezera1"    />
                    
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Introduzca  Datos" styleClass="outputText2"  />
                        </f:facet>
                        
                        <h:outputText value="Actividad Producción" styleClass="outputText2" />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputText styleClass="inputText" size="50" value="#{ManagedActividadesProduccion.actividadesProduccionbean.nombreActividad}" onkeypress="valMAY();" id="nombre" /> 
                        
                        <h:outputText value="Descripción" styleClass="outputText2"  />
                        <h:outputText  styleClass="outputText2"  value="::"/>  
                        <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{ManagedActividadesProduccion.actividadesProduccionbean.obsActividad}" id="obs"   />
                        
                        <h:outputText value="Estado" styleClass="outputText2"   />                                                
                        <h:outputText  styleClass="outputText2" value="::"/>                                
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesProduccion.actividadesProduccionbean.estadoReferencial.codEstadoRegistro}" >
                            <f:selectItems value="#{ManagedActividadesProduccion.estadoRegistro}"  />
                        </h:selectOneMenu>
                        <%--inicio ale unidad medida--%>
                        <h:outputText value="Unidad Medida" styleClass="outputText2"  rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}" />
                        <h:outputText  styleClass="outputText2" value="::" rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}"/>
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesProduccion.actividadesProduccionbean.unidadesMedida.codUnidadMedida}" rendered="#{ManagedActividadesProduccion.actividadesProduccionbean.tipoActividad.codTipoActividad=='1'}" >
                            <f:selectItems value="#{ManagedActividadesProduccion.unidadesMedidaList}"  />
                        </h:selectOneMenu>
                        <%--final ale unidad medida--%>
                    </h:panelGrid>
                    
                    <br>
                    <h:commandButton value="Guardar" styleClass="commandButton" action="#{ManagedActividadesProduccion.modificarActividadesProduccion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar"  styleClass="commandButton" action="#{ManagedActividadesProduccion.Cancelar}"/>
                </div>                                
            </h:form>
        </body>
    </html>
    
</f:view>

