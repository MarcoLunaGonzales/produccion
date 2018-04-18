<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    <script type="text/javascript" src="../../js/general.js"></script>
    <script type="text/javascript">
        function validarGuardar()
        {
            document.getElementById("form1:cantidad").style.backgroundColor='';
            if(document.getElementById("form1:cantidad").value=='')
            {
                alert('Debe registrar la cantidad de la presentacion');
                document.getElementById("form1:cantidad").style.backgroundColor='rgb(255, 182, 193)';
                document.getElementById("form1:cantidad").focus();
                return false;
            }
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
                    <h:outputText value="Edición de Presentación Primaria"/>
                </f:facet>
                <h:panelGrid columns="3" >
                    <h:outputText value="Envase Primario" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProdVersion.presentacionesPrimariasEditar.envasesPrimarios.codEnvasePrim}">
                        <f:selectItems value="#{ManagedComponentesProdVersion.envasesPrimariosSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Cantidad" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:inputText value="#{ManagedComponentesProdVersion.presentacionesPrimariasEditar.cantidad}" styleClass="inputText"
                    onkeypress="valNum();" id="cantidad"/>
                    <h:outputText value="Tipo Programa Producción" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.presentacionesPrimariasEditar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText">
                        <f:selectItems value="#{ManagedComponentesProdVersion.tiposProgramaProduccionSelectList}"/>
                    </h:selectOneMenu>
                    <h:outputText value="Estado" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:selectOneMenu value="#{ManagedComponentesProdVersion.presentacionesPrimariasEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                        <f:selectItem itemLabel="ACTIVO" itemValue="1" />
                        <f:selectItem itemLabel="NO ACTIVO" itemValue="2" />
                    </h:selectOneMenu>
                    
                </h:panelGrid>
            </rich:panel>
            <center style="margin-top:1em;">
                <a4j:commandButton value="Guardar" action="#{ManagedComponentesProdVersion.guardarEdicionPresentacionPrimaria_action}" styleClass="btn"
                onclick="if(!validarGuardar()){return false;}"
                oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('Se guardo la edicion de la presentacion primaria');window.location.href='navegadorPresentacionesPrimariasVersion.jsf?reg='+(new Date()).getTime().toString();}else{alert('#{ManagedComponentesProdVersion.mensaje}');}"/>
                <a4j:commandButton value="Cancelar" oncomplete="window.location.href='navegadorPresentacionesPrimariasVersion.jsf?data='+(new Date()).getTime().toString();" styleClass="btn"/>
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



