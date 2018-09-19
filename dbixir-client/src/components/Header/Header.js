import React from 'react';
import NavItem from '../NavItem/NavItem';
import { HOME_PAGE, CONNECT_PAGE, QUERY_PAGE, TABLES_PAGE} from "../../constants/apiUrls";
 
const header = (props) => (
    <div className="NavItemList">
        <NavItem key="1" navItemName="Main" navItemUrl={HOME_PAGE} />
        <NavItem key="2" navItemName="Connect" navItemUrl={CONNECT_PAGE} />
        <NavItem key="3" navItemName="Tables"  navItemUrl={TABLES_PAGE} />
        <NavItem key="4" navItemName="Query Builder" navItemUrl={QUERY_PAGE} />
    </div>
);

export default header;