<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
    <script type="text/javascript" src='../js/general.js' ></script> 
    <script>
                function validar(){
                   var nombreproducto=document.getElementById('form1:nombreproducto');
                   if(nombreproducto.value==''){
                     alert('El campo Nombre Comercial se encuentra vacio.');
                     nombreproducto.focus();
                     return false;
                   }
                   return true;
                }
    </script>
    </he
</head>
<body>
    <h:form id="form1"  >
        <div align="center">
            <br>
            <br>
            <h3>  <h:outputText value="Editar Nombre Comercial" styleClass="tituloCabezera1" />     </h3>
            <br>
            <br>
            <h:panelGrid columns="3" styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;">
                <f:facet name="header" >
                    <h:outputText value="Introduzca Datos" styleClass="outputText2"    />
                </f:facet>                                
                <h:outputText value="Nombre Comercial" styleClass="outputText2"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.nombreProducto}" onkeypress="valMAY();" id="nombreproducto"/>
                <%--  
                <h:outputText value="Producto Controlado" styleClass="outputText2"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:selectOneMenu styleClass="inputText" value="#{productos.productoBean.prodControlado}" >
                    <f:selectItem itemValue="0" itemLabel="SI" />
                    <f:selectItem itemValue="1" itemLabel="NO" />
                </h:selectOneMenu>    --%>                
                
                
                <%-- <h:outputText value="Lote Mínimo" styleClass="outputText2"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.loteMinimoProd}" onkeypress="valNum();" id="loteminimo"/>
                
                <h:outputText value="Lote Máximo" styleClass="outputText2"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.loteMaximoProd}" onkeypress="valNum();" id="lotemaximo"/>                    
                
                <h:outputText value="RN" styleClass="outputText2"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.rnProd}" id="rnproducto"/>                    
                
                <!--calendario-->        
      
                
                <h:outputText styleClass="outputText2" value="Vigencia Producto"   />                        
                <h:outputText value="::" styleClass="outputText2"  />
                <a4j:outputPanel styleClass="outputText" id="calendar1" layout="block"  >
                    <rich:calendar popup="true" 
                                   datePattern="dd/MM/yyyy"  value="#{productos.productoBean.vigenciaProd}" />                            
                </a4j:outputPanel>                                                
                
                
                <!--calendario-->
       
                <h:outputText styleClass="outputText2" value="Expiración Producto"  />                        
                <h:outputText value="::" styleClass="outputText2"  />
                <a4j:outputPanel styleClass="outputText" id="calendar2" layout="block"   >
                    <rich:calendar popup="true" 
                                   datePattern="dd/MM/yyyy"  value="#{productos.productoBean.expiracionProd}" />                            
                </a4j:outputPanel>                                                
                
                <h:outputText styleClass="outputText2" value="Tamaño Sub Lote"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.tamSubLote}" onkeypress="valNum();" id="obsTamSubLote"/>
                
                <h:outputText styleClass="outputText2" value="Tamaño Lote"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputText size="50" styleClass="inputText" value="#{productos.productoBean.tamanoLoteProd}" onkeypress="valNum();" id="obsTamañoLote"/>
                --%>
                <h:outputText styleClass="outputText2" value="Observaciones"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:inputTextarea styleClass="inputText" rows="3" cols="48" value="#{productos.productoBean.obsProd}"   />
                
                <%--h:outputText styleClass="outputText2" value="Estado"  />
                <h:outputText value="::" styleClass="outputText2"  />
                <h:selectOneMenu styleClass="inputText" value="#{productos.productoBean.estadoProducto.codEstadoProducto}" >
                    <f:selectItems value="#{productos.estadoproducto}"  />
                </h:selectOneMenu--%>
                
            </h:panelGrid>        
            <br>
            <h:commandButton styleClass="btn" value="Guardar" action="#{productos.modificarProducto}"  onclick="return validar();" />
            <h:commandButton styleClass="btn" value="Cancelar" action="#{productos.actionCancelar}"/>      
            
            <%--</h:panelGrid>--%>
        </div>
    </h:form>
</body>
</html>

</f:view>

