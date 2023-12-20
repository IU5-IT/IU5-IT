import {useNavigate} from 'react-router-dom';
import {FC, useEffect} from 'react';
import {ICity} from "../../models/models.ts";
import List from "../List.tsx";
import CityItem from "../CityItem/CityItem.tsx";
import './CitiesList.css'
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {fetchCities} from "../../store/reducers/ActionCreator.ts";
import LoadAnimation from "../Popup/MyLoaderComponent.tsx";
import MyComponent from "../Popup/Popover.tsx";
import Button from "react-bootstrap/Button";

interface CitiesListProps {
    setPage: () => void
}

const CitiesList: FC<CitiesListProps> = ({setPage}) => {
    const dispatch = useAppDispatch()
    const {cities, isLoading, error, success, basketID} = useAppSelector(state => state.cityReducer)
    const navigate = useNavigate();
    const {searchValue} = useAppSelector(state => state.progressReducer)

    useEffect(() => {
        setPage()
        dispatch(fetchCities(searchValue))
    }, [searchValue]);

    const didTapBasket = () => {
        navigate(`/hikes/${basketID}`);
    }

    if (!cities) {
        return <h3>Данных нет</h3>
    }

    return (
        <>
            {isLoading && <LoadAnimation/>}
            {error != "" && <MyComponent isError={true} message={error}/>}
            {success != "" && <MyComponent isError={false} message={success}/>}
            <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end'}}>
                <Button
                    variant="primary"
                    onClick={didTapBasket}
                    disabled={basketID == 0}
                    style={{position: 'absolute', right: 40}}
                >
                    Создать поход
                </Button>
            </div>
            <List items={cities ?? []} renderItem={(city: ICity) =>
                <CityItem
                    key={city.id}
                    city={city}
                    isServer={true}
                    onClick={(num) => navigate(`/cities/${num}`)}
                />
            }
            />
        </>
    )
};

export default CitiesList;