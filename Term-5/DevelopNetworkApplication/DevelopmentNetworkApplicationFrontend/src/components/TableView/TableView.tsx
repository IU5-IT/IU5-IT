import {FC} from "react";
import './TableView.css'
import {IDestinationHikes} from "../../models/models.ts";
import {useAppDispatch} from "../../hooks/redux.ts";
import {deleteDestHikeById} from "../../store/reducers/ActionCreator.ts";
import {citySlice} from "../../store/reducers/CitySlice.ts";

interface TableViewProps {
    status: number
    destHikes: IDestinationHikes[]
    setPage: (name: string, id: number) => void
    hikeID: string
}

const TableView: FC<TableViewProps> = ({destHikes, status, setPage, hikeID}) => {
    const dispatch = useAppDispatch()
    const {minus} = citySlice.actions

    const handleDelete = (id: number) => {
        dispatch(minus())
        dispatch(deleteDestHikeById(id, hikeID, setPage))
    }

    return (
        <>
            <table>
                <thead>
                <tr>
                    <th className="number">Номер</th>
                    <th>Фотография</th>
                    <th>Название города</th>
                    <th>Описание</th>
                </tr>
                </thead>
                <tbody>
                {destHikes.map((item, index) => (
                    <tr key={index}>
                        <td className="city-number-td">{item.serial_number}</td>
                        <td className="image-td">
                            <img src={item.city.image_url} alt="photo"/>
                        </td>
                        <td className="city-name-td">{item.city.city_name}</td>
                        <td>{item.city.description}</td>
                        {
                            status != 2 && <td className="delete-td">
                                <img
                                    className="delete-button-td"
                                    src="/dustbin.png"
                                    alt="Delete"
                                    onClick={() => handleDelete(item.id)}
                                />
                            </td>
                        }
                    </tr>
                ))}
                </tbody>
            </table>
        </>
    );
};

export default TableView;
