<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    <script type="text/javascript" src="../../js/general.js"></script>
   <script type="text/javascript">
        function validarGuardar()
        {
            document.getElementById("form1:cantidad").style.backgroundColor='';
            
            if(parseInt(document.getElementById("form1:cantidad").value)<=0)
            {
                alert('La cantidad de la presentacion debe ser mayor a 0');
                document.getElementById("form1:cantidad").style.backgroundColor='rgb(255, 182, 193)';
                document.getElementById("form1:cantidad").focus();
                return false;
            }
            return true;
        }
  </script>
</head>
<body >
    
    <a4j:form id="form1"  >
        <div style="text-align:center">
            <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesPresProdAgregar}"/>
            <rich:panel headerClass="headerClassACliente" style="width:50%">
                <f:facet name="header">
                    <h:outputText value="Datos Generales"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2"/>
                    <h:outputText value="Nombre Producto Semiterminado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2"/>
                    <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.producto.nombreProducto}" styleClass="outputText2"/>
                </h:panelGrid>

            </rich:panel>
            <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:1em">
                <f:facet name="header">
                    <h:outputText value="Agregar Presentación Secundaria"/>
                </f:facet>
                <h:panelGrid columns="3" >
                    <h:outputText value="Presentación" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProdVersion.componentesPresProdAgregar.presentacionesProducto.codPresentacion}">
                        <f:selectItem itemLabel="--Seleccione una opcion--" itemValue="0"/>
                        <f:selectItems value="#{ManagedComponentesProdVersion.presentacionesProductoSelectList}"/>
                        <a4j:support event="onchange" action="#{ManagedComponentesProdVersion.codPresentacionAgregar_change}"
                        reRender="cantidad"/>
                    </h:selectOneMenu>
                    <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedComponentesProdVersion.componentesPresProdAgregar.cantCompProd}" styleClass="inputText"
                    onkeypress="valNum();" id="cantidad" onblur="valorPorDefecto(this);validarMayorACero(this);"/>
                    <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.componentesPresProdAgregar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposProgramaProduccionSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Estado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="Activo" styleClass="outputText2"/>
                    
                </h:panelGrid>
            </rich:panel>
            <center style="margin-top:1em;">
                <a4j:commandButton value="Guardar" action="#{ManagedComponentesProdVersion.guardarNuevoComponentesPresProd_action}" styleClass="btn"
                onclick="if(!validarGuardar()){return false;}"
                oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se guardo el nuevo registro');window.location.href='navegadorPresentacionesSecundarias.jsf?reg='+(new Date()).getTime().toString();}else{alert('#{ManagedComponentesProdVersion.mensaje}');}"/>
                <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorPresentacionesSecundarias.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
            </center>
        </div>
        
    </a4j:form>
    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
    </a4j:status>

    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

        <div align="center">
            <h:graphicImage value="../../img/load2.gif" />
        </div>
    </rich:modalPanel>
    <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
</body>
</html>

</f:view>



