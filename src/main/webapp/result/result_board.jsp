<%@ page contentType="text/html; charset=UTF-8"%>
<%
/*
* subject: bheader 페이지
* @original author: SearchTool
*/
thisCollection = "v_bheader";
if (collection.equals("ALL") || collection.equals(thisCollection)) {
    int count = wnsearch.getResultCount(thisCollection);
    int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

    if (thisTotalCount > 0) {
%>
        <div class="board_box">
            <div class="board_tit_box">
                <strong class="tit"><%= wnsearch.getCollectionKorName(thisCollection) %></strong>
                <span class="num">(<%= numberFormat(thisTotalCount) %>건)</span>
                <%
                if (collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT) {
                %>
                    <a href="#" onClick="javascript:doCollection('<%= thisCollection %>');">
                        <span class="btn_more">더보기</span>
                    </a>
                <%
                }
                %>
                <%
                if (!collection.equals("ALL")) {
                %>
                    <div class="board_select_box">
                        <!-- 셀렉트 박스 -->
                        <%
                        if (sort.equals("RANK/DESC")) {
                        %>
                            <select class="selectpicker" id="sortoption" onchange="doSorting(this.value);">
                                <option value="RANK/DESC" selected="selected">정확도순</option>
                                <option value="DATE/DESC">최신순</option>
                                <option value="DATE/ASC">오래된순</option>
                            </select>
                        <%
                        } else if (sort.equals("DATE/ASC")) {
                        %>
                            <select class="selectpicker" id="sortoption" onchange="doSorting(this.value);">
                                <option value="RANK/DESC">정확도순</option>
                                <option value="DATE/DESC">최신순</option>
                                <option value="DATE/ASC" selected="selected">오래된순</option>
                            </select>
                        <%
                        } else {
                        %>
                            <select class="selectpicker" id="sortoption" onchange="doSorting(this.value);">
                                <option value="RANK/DESC">정확도순</option>
                                <option value="DATE/DESC" selected="selected">최신순</option>
                                <option value="DATE/ASC">오래된순</option>
                            </select>
                        <%
                        }
                        if (COLLECTIONVIEWCOUNT == 10) {
                        %>
                            <select class="selectpicker" id="resultcnt2" onchange="resultCnt2(this.value);">
                                <option value="10" selected="selected">10개</option>
                                <option value="20">20개</option>
                            </select>
                        <%
                        } else {
                        %>
                            <select class="selectpicker" id="resultcnt2" onchange="resultCnt2(this.value);">
                                <option value="10">10개</option>
                                <option value="20" selected="selected">20개</option>
                            </select>
                        <%
                        }
                        %>
                    </div>
                <%
                }
                %>
            </div>
            <%
            for (int idx = 0; idx < count; idx++) {
                String DOCID = wnsearch.getField(thisCollection, "DOCID", idx, false);
                String TITLE = wnsearch.getField(thisCollection, "TITLE", idx, false);
                String DATE = wnsearch.getField(thisCollection, "DATE", idx, false);
                String POSTERNM = wnsearch.getField(thisCollection, "POSTER_NAME", idx, false);
                String DEPT = wnsearch.getField(thisCollection, "DEPT", idx, false);
                String CONTENTS = wnsearch.getField(thisCollection, "CONTENTS", idx, false);
                String FILE_NAME = wnsearch.getField(thisCollection, "ATT_NAMES", idx, false);
                String FILE_EXTS = wnsearch.getField(thisCollection, "ATT_EXTS", idx, false);
                String FILE_CONTENTS = wnsearch.getField(thisCollection, "FILE_CONTENTS", idx, false);
                String ATT_ORDS = wnsearch.getField(thisCollection, "ATT_ORDS", idx, false);
                String ATT_PATHS = wnsearch.getField(thisCollection, "ATT_PATHS", idx, false);
                String BRDFULLPATH = wnsearch.getField(thisCollection, "BRDFULLPATH", idx, false);
                String ALIAS = wnsearch.getField(thisCollection, "ALIAS", idx, false);
                
                TITLE = wnsearch.getKeywordHl(TITLE, "<font color=red>", "</font>");
                POSTERNM = wnsearch.getKeywordHl(POSTERNM, "<font color=red>", "</font>");
                CONTENTS = wnsearch.getKeywordHl(CONTENTS, "<font color=red>", "</font>");
                String URL = "URL 정책에 맞게 작성해야 합니다.";

                if (CONTENTS.equals("||")) {
                    CONTENTS = "";
                } else if (CONTENTS.equals("||||")) {
                    CONTENTS = "";
                } else if (CONTENTS.equals("||||||")) {
                    CONTENTS = "";
                }

                CONTENTS = CONTENTS.replaceAll("[||]", "");

                TITLE = TITLE.replaceAll("'", "");
                TITLE = TITLE.replaceAll("\"", "");
            %>
                <div class="board_cont_box">
                    <div class="tit_box">
                        <a href="javascript: openBbs('<%= DOCID %>', '<%= K %>')" class="tit"><%= TITLE %></a>
                    </div>
                    <span class="date"><%= DATE %></span>
                    <div class="cont">
                        <%= CONTENTS %>
                    </div>
                    <div class="tit_info">
                        <span><%= BRDFULLPATH %></span>
                    </div>
                </div>
            <%
            }

            if (collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT) {
            %>
                </div>
            <%
            } else if (!collection.equals("ALL") && thisTotalCount > 10) {
            %>
                </div>
                <div class="page_btn_num" id="pagenum">
                    <%= wnsearch.getPageLinks(startCount, totalCount, 10, 10) %>
                </div>
            <%
            }
        }
    }
%>
