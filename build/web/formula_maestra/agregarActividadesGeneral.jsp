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
            var tabla=document.getElementById('form1:dataActividades');
            for(var i=1;i<tabla.rows.length;i++)
                {
                    if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked==true)
                        {
                            if(!validarMayorACero(tabla.rows[i].cells[1].getElementsByTagName('input')[0]))
                            {
                                return false;
                            }
                        }
                }
                return true;
        }
        function actionGuardar()
        {
            document.getElementById('form1:buttonGuardar').style.visibility='hidden';
            document.getElementById('buttonCancelar').style.visibility='hidden';
            document.getElementById('form1:progress').style.visibility='visible';
            
        }

         
    </script>
</head>
<body>

<a4j:form id="form1">
    <div align="center">
        <br>
        <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarActividadesAdicionarGeneral}"/>
        <rich:panel headerClass="headerClassACliente" style="width:80%">
            <f:facet name="header">
                <h:outputText value="Agregar Actividades a Todos los productos"/>
            </f:facet>
            <h:panelGrid columns="6">
                <h:outputText value="Area Producto" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneral.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}"
                styleClass="inputText">
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaSelectList}"/>
                </h:selectOneMenu>
                <h:outputText value="Forma Farmaceútica" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneral.formulaMaestra.componentesProd.forma.codForma}"
                styleClass="inputText">
                    <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.formasFarmaceuticasSelectList}"/>
                </h:selectOneMenu>
                <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.codAreaEmpresa}" styleClass="inputText">
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                </h:selectOneMenu>
                <h:outputText value="Producto con Presentaciones" styleClass="outputTextBold"/>
                <h:outputText value="::" styleClass="outputTextBold"/>
                <h:selectOneRadio value="#{ManagedActividadesFormulaMaestra.productosConPresentaciones}" styleClass="outputText2">
                    <f:selectItem itemValue='true' itemLabel="SI"/>
                    <f:selectItem itemValue='false' itemLabel="NO"/>
                </h:selectOneRadio>
            </h:panelGrid>
        </rich:panel>
        
        
        <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesFMAdicionarGeneralList}" var="data" id="dataActividades"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                        headerClass="headerClassACliente"
                        style="margin-top:1em"
                        columnClasses="tituloCampo">
            <f:facet name="header">
                <rich:columnGroup>
                    <rich:column>
                        <h:outputText value=""/>
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Orden"/>
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Actividad"/>
                    </rich:column>
                </rich:columnGroup>
            </f:facet>
            <rich:column>
                <h:selectBooleanCheckbox value="#{data.checked}"  />
            </rich:column>
            <rich:column>
                <h:inputText value="#{data.ordenActividad}" styleClass="inputText" onkeypress="valNum();" onblur="valorPorDefecto(this)" size="10"/>
            </rich:column>
            <rich:column>
                <h:outputText value="#{data.actividadesProduccion.nombreActividad}" styleClass="outputText2" />
            </rich:column>

        </rich:dataTable>

            <a4j:commandButton value="Guardar" id="buttonGuardar" styleClass="btn"
                               action="#{ManagedActividadesFormulaMaestra.guardarActividadesAdicionarGeneral_action}"
                               onclick="if(!validarRegistro()){return false;}"
                               oncomplete="if(#{ManagedActividadesFormulaMaestra.mensaje eq '1'}){alert('Se registro la actividad general');window.location.href='navegadorFormulaMaestraActividad.jsf?data='+(new Date()).getTime().toString()}else{alert('#{ManagedActividadesFormulaMaestra.mensaje}');}"
             />
            <a4j:commandButton value="Cancelar" id="buttonCancelar" styleClass="btn"
                               oncomplete="window.location.href='navegadorFormulaMaestraActividad.jsf?cancel='+(new Date()).getTime().toString();"
             />
             
    </div>
</a4j:form>
<a4j:status id="statusPeticion"
            onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
            onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
</a4j:status>

<rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                 minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

    <div align="center">
        <h:graphicImage value="../img/load2.gif" />
    </div>
</rich:modalPanel>
</body>
</html>

</f:view>

