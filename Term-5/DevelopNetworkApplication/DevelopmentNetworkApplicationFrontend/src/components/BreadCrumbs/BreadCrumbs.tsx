import {Link} from 'react-router-dom';
import {FC} from "react";
import './breadcrumbs.css'

export interface BreadcrumbsProps {
    paths: Breadcrumb[]
}

export interface Breadcrumb {
    name: string
    to: string
}

const Breadcrumbs: FC<BreadcrumbsProps> = ({paths}) => {

    return (
        <div className={'mx-5 my-2'}>
            <div className="breadcrumbs">
                {paths.map((path, index) => (
                    <div key={index} className="breadcrumb-item-2">
                        {index === paths.length - 1 ? (
                            path.name
                        ) : (
                            <Link to={path.to}>{path.name}</Link>
                        )}
                    </div>
                ))}
            </div>
        </div>
    );
};

export default Breadcrumbs;
