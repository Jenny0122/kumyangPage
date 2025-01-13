<%@ page pageEncoding="UTF-8" %>
<%@ include file="./api/WNDefine.jsp" %>
<%!

    static String SEARCH_IP = "10.1.2.204";
    static int SEARCH_PORT = 7000;
    static String MANAGER_IP = "10.1.2.204";
    static int MANAGER_PORT = 7800;

    public String[] COLLECTIONS = new String[]{"appr", "board"};
    public String[] COLLECTIONS_NAME = new String[]{"appr", "board"};
    public String[] MERGE_COLLECTIONS = new String[]{""};

    public class WNCollection {
        public String[][] MERGE_COLLECTION_INFO = null;
        public String[][] COLLECTION_INFO = null;

        WNCollection() {
            COLLECTION_INFO = new String[][]
                    {
                            {
                                    "appr", // set index name
                                    "appr", // set collection name
                                    "0,3",  // set pageinfo (start,count)
                                    "1,0,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
                                    "RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
                                    "basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
                                    "TITLE,CONTENTS,FILE_NAME,FILE_CONTENTS,USERNM,DEPT,DOCREGNO",// set search field
                                    "DOCID,DATE,APPRID,TITLE,USERNM,CONTENTS/300,DEPT,DOCREGNO,APPROVALDATE,APPROVALTYPE,APPROVALSTATUS,WORDTYPE,EXTERNALDOC,EXTERNALDOCTYPE,ATTACHCOUNT,ISSECURITY,SUMMARYDOC,HASOPINION,DOCTYPE,FILE_NAME,FILE_EXTS,FILE_CONTENTS/300,FILE_ID,UPDATEDATE,OWNERIDS,FLDROWNERID,FLDROWNERNAME,ALIAS",// set document field
                                    "", // set date range
                                    "", // set rank range
                                    "", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
                                    "", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
                                    "", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
                                    "", // set filter operation (<fieldname:operator:value>)
                                    "", // set groupby field(field, count)
                                    "", // set sort field group(field/order,field/order,...)
                                    "", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
                                    "", // set categoryGroupBy (fieldname:value)
                                    "", // set categoryQuery (fieldname:value)
                                    "", // set property group (fieldname,min,max, groupcount)
                                    "FLDROWNERID,ALIAS,OWNERIDS", // use check prefix query filed
                                    "DATE", // set use check fast access field
                                    "", // set multigroupby field
                                    "", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
                                    "", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
                                    "전자결재" // collection display name
                            },
                            {
                                    "board", // set index name
                                    "board", // set collection name
                                    "0,3",  // set pageinfo (start,count)
                                    "1,0,0,0,0", // set query analyzer (useKMA,isCase,useOriginal,useSynonym, duplcated detection)
                                    "RANK/DESC,DATE/DESC",  // set sort field (field,order) multi sort '/'
                                    "basic,rpfmo,100",  // set sort field (field,order) multi sort '/'
                                    "TITLE,CONTENTS,FILE_NAME,FILE_CONTENTS",// set search field
                                    "DOCID,DATE,TITLE,POSTER_ID,POSTER_NAME,CONTENTS/300,ATT_CNT,FILE_NAME,ATT_EXTS,ATT_ORDS,FILE_CONTENTS/300,BRD_ID,MODIFY_DATE,COMMENT_NUM,BRDFULLPATH,BRD_TYPE,READNOTMEMBER,ALIAS",// set document field
                                    "", // set date range
                                    "", // set rank range
                                    "", // set prefix query, example: <fieldname:contains:value1>|<fieldname:contains:value2>/1,  (fieldname:contains:value) and ' ', or '|', not '!' / operator (AND:1, OR:0)
                                    "", // set collection query (<fieldname:contains:value^weight | value^weight>/option...) and ' ', or '|'
                                    "", // set boost query (<fieldname:contains:value> | <field3:contains:value>...) and ' ', or '|'
                                    "", // set filter operation (<fieldname:operator:value>)
                                    "", // set groupby field(field, count)
                                    "", // set sort field group(field/order,field/order,...)
                                    "", // set categoryBoost(fieldname,matchType,boostID,boostKeyword)
                                    "", // set categoryGroupBy (fieldname:value)
                                    "", // set categoryQuery (fieldname:value)
                                    "", // set property group (fieldname,min,max, groupcount)
                                    "POSTER_NAME,ALIAS", // use check prefix query filed
                                    "DATE", // set use check fast access field
                                    "", // set multigroupby field
                                    "", // set auth query (Auth Target Field, Auth Collection, Auth Reference Field, Authority Query)
                                    "", // set Duplicate Detection Criterion Field, RANK/DESC,DATE/DESC
                                    "게시판" // collection display name
                            }
                    };
        }
    }
%>
