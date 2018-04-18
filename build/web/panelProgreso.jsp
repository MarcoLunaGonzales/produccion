<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<a4j:status id="statusPeticion"
            onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
            onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox');cargarChosen();">
</a4j:status>

<rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                 minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

    <div align="center">
        <h:graphicImage value="/img/load2.gif" />
    </div>
</rich:modalPanel>
<a4j:loadScript src="/js/chosen.js" />
<script type="text/javascript">
    cargarChosen();
</script>