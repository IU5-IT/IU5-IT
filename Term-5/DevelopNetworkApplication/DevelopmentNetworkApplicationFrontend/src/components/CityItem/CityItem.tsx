import {FC} from 'react';
import {ICity} from '../../models/models.ts';
import './CardItem.css'
import {addCityIntoHike} from "../../store/reducers/ActionCreator.ts";
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {citySlice} from "../../store/reducers/CitySlice.ts";

interface CityItemProps {
    city: ICity;
    onClick: (num: number) => void,
    isServer: boolean
}

const CityItem: FC<CityItemProps> = ({city, onClick, isServer}) => {

    const dispatch = useAppDispatch()
    const {increase} = citySlice.actions
    const {isAuth} = useAppSelector(state => state.userReducer)
    const {serialNumber} = useAppSelector(state => state.cityReducer)

    const plusClickHandler = () => {
        dispatch(increase())
        dispatch(addCityIntoHike(city.id, serialNumber, city.city_name ?? "Без названия"))
    }

    return (
        <div className="card-city-item" data-city-id={city.id}>
            <img
                src={city.image_url}
                alt="Image"
                className="photo"
                onClick={() => onClick(city.id)}
                id={`photo-${city.id}`}
            />
            {isServer && isAuth && (
                <div className="circle" onClick={plusClickHandler}>
                    <img
                        src="/plus.png"
                        alt="+"
                        className="deleted-trash"
                    />
                </div>
            )}
            <div className="container-card" onClick={() => onClick(city.id)}>{city.city_name}</div>
        </div>
    );
};

export default CityItem;
