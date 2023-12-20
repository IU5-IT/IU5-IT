import {useState, ChangeEvent, FormEvent, FC, useEffect} from 'react';
import {Button, Form, Container, Row, Col} from 'react-bootstrap';
import {createCity} from "../../store/reducers/ActionCreator.ts";
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import MyComponent from "../Popup/Popover.tsx";
import Cookies from "js-cookie";

interface CityData {
    cityName: string;
    description: string;
    image: File | null;
}

interface AddCityProps {
    setPage: () => void
}

const CreateCityPage: FC<AddCityProps> = ({setPage}) => {
    const [cityData, setCityData] = useState<CityData>({
        cityName: '',
        description: '',
        image: null,
    });
    const {error, success} = useAppSelector(state => state.cityReducer)
    const role = Cookies.get('role')
    const dispatch = useAppDispatch()
    const handleInputChange = (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
        const {name, value} = e.target;
        setCityData({...cityData, [name]: value});
    };

    useEffect(() => {
        setPage()
    }, []);

    const save = () => {
        dispatch(createCity(cityData.cityName, cityData.description, cityData.image))
    }

    const handleImageChange = (e: ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            cityData.image = file
        }
    };

    const handleSubmit = (e: FormEvent) => {
        e.preventDefault();
        // Handle form submission logic, e.g., dispatching data to the server
        console.log('City data submitted:', cityData);
    };

    if (role != '2') {
        return <h2>нет прав</h2>
    }
    return (
        <>
            {error != "" && <MyComponent isError={true} message={error}/>}
            {success != "" && <MyComponent isError={false} message={success}/>}

            <Container>
                <Row className="justify-content-md-center">
                    <Col xs={12} md={6}>
                        <h2>Добаление города</h2>
                        <Form onSubmit={handleSubmit}>
                            <Form.Group controlId="formCityName">
                                <Form.Label>Название города</Form.Label>
                                <Form.Control
                                    type="text"
                                    placeholder="Название"
                                    name="cityName"
                                    value={cityData.cityName}
                                    onChange={handleInputChange}
                                    required
                                />
                            </Form.Group>

                            <Form.Group controlId="formCityDescription">
                                <Form.Label>Описание города</Form.Label>
                                <Form.Control
                                    as="textarea"
                                    rows={3}
                                    placeholder="Описание"
                                    name="description"
                                    value={cityData.description}
                                    onChange={handleInputChange}
                                    required
                                />
                            </Form.Group>

                            <Form.Group controlId="formCityImage">
                                <Form.Label>Фотография города</Form.Label>
                                <Form.Control
                                    type="file"
                                    accept="image/*"
                                    onChange={handleImageChange}
                                />
                            </Form.Group>

                            <Button variant="primary" type="submit" style={{marginTop: '30px'}} onClick={save}>
                                Создать
                            </Button>
                        </Form>
                    </Col>
                </Row>
            </Container>
        </>
    );
};

export default CreateCityPage;
