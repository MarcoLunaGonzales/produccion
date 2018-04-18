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
    </script>
</head>
<body>

<a4j:form id="form1"  >

<div align="center">
    <br>
    <h:outputText value="Agregar Actividad Indirecta Producción" styleClass="outputTextTituloSistema"    />

    <h:outputText value="#{ManagedActividadesProgramaProduccionIndirecto.cargarContenidoAgregarActividades}" />
    <rich:dataTable value="#{ManagedActividadesProgramaProduccionIndirecto.actividadesProgramaProduccionIndirectoAdicionarList}" var="data" id="dataCadenaCliente"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
    >
        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
                
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checked}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Orden"  />
            </f:facet>
            <h:inputText value="#{data.orden}" styleClass="inputText" onkeypress="valNum();" size="10"/>
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Actividades Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}" styleClass="" />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre"/>
            </f:facet>
            <h:inputText value="#{data.horasHombre}" styleClass="inputText"/>
        </h:column>

        
    </rich:dataTable>
    
    <br>
    <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedActividadesProgramaProduccionIndirecto.guardarActividadIndirectaProduccion_action}" 
                       oncomplete="if(#{ManagedActividadesProgramaProduccionIndirecto.mensaje eq '1'}){alert('Se registraron la actividades indirectas');window.location.href='navegador_actividades_programa_produccion_indirecto.jsf?data='+(new Date()).getTime().toString();}
                       else{alert('#{ManagedActividadesProduccion.mensaje}');}"/>
       <a4j:commandButton value="Cancelar"  styleClass="btn" onclick = "window.location.href='navegador_actividades_programa_produccion_indirecto.jsf?data='+(new Date()).getTime().toString();"/>
</div>

</a4j:form>
    
<a4j:status id="statusPeticion"
            onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
            onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
</a4j:status>

<rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                 minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

    <div align="center">
        <h:graphicImage value="../img/load2.gif" />
    </div>
</rich:modalPanel>
</body>
</html>

</f:view>

