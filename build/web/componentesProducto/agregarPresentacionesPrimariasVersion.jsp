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
                function validarRegistro()
                {
                    var primaria=document.getElementById('form1:envasePrimario');
                    if(!(parseInt(primaria.value)>0))
                        {
                            alert('Debe seleccion un envase primario para la presentación')
                            return false;
                        }
                    if(!(parseInt(document.getElementById('form1:cantidad').value)>0))
                     {
                         alert('No puede registrar una cantidad menor o igual a cero');
                         return false;
                     }
                     return true;
                }

function valEnteros()
{
  if ((event.keyCode < 48 || event.keyCode > 57) )
     {
        alert('Introduzca solo Numeros Enteros');
        event.returnValue = false;
     }
}
            </script>
        </head>
        <body >    
            <div style="text-align:center">                            
                <h:form id="form1"  >
                    <h:outputText value="#{ManagedComponentesProducto.cargarAgregarPresentacionPrimaria}"/>
                    <h:outputText value="#{ManagedComponentesProducto.nombreComProd}" styleClass="outputText2" />
                    <div align="center">                
                        <h:outputText value="Registrar Producto Semiterminado" styleClass="tituloCabezera1"    />                                
                        <h:panelGrid columns="4" styleClass="panelgrid" headerClass="headerClassACliente" style="width:40%;border:1px solid #cccccc">
                            <f:facet name="header" >
                                <h:outputText value="Introduzca  Datos" styleClass="outputText2"    />
                            </f:facet>                    
                            <h:outputText value="Envase Primario " styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>  
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.presentacionesPrimarias.envasesPrimarios.codEnvasePrim}" id="envasePrimario">
                                <f:selectItems value="#{ManagedComponentesProducto.envasesPrimariosList}"  />
                            </h:selectOneMenu> 
                            <h:outputText  styleClass="outputText2"  value=""/>  
                            
                            <h:outputText value="Cantidad " styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>  
                            <h:inputText styleClass="inputText" size="20" onkeypress="valEnteros();" value="#{ManagedComponentesProducto.presentacionesPrimarias.cantidad}"  id="cantidad" />
                            <h:outputText  styleClass="outputText2"  value=""/>

                            <h:outputText value="Tipos Programa Produccion " styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.presentacionesPrimarias.tiposProgramaProduccion.codTipoProgramaProd}">
                                <f:selectItems value="#{ManagedComponentesProducto.tiposProgramaProduccionList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>
                            
                            
                            <h:outputText value="Estado " styleClass="outputText2" />
                            <h:outputText  styleClass="outputText2"  value="::"/>
                            <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.presentacionesPrimarias.estadoReferencial.codEstadoRegistro}">
                                <f:selectItems value="#{ManagedComponentesProducto.estadoRegistroList}"  />
                            </h:selectOneMenu>
                            <h:outputText  styleClass="outputText2"  value=""/>




                            
                        </h:panelGrid>
                        <h:commandButton value="Guardar" onclick="return validarRegistro()" styleClass="commandButton" action="#{ManagedComponentesProducto.guardarPresentacionesPrimariasVersion}"  />
                        <a4j:commandButton value="Cancelar"  styleClass="commandButton" onclick="location='navegadorPresentacionesPrimariasVersion.jsf'" />
                    </div>            
                </h:form>
            </div>    
        </body>
    </html>
    
</f:view>

