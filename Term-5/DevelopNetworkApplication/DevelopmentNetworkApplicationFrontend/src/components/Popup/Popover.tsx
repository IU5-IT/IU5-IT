import {useEffect} from 'react';
import {ToastContainer, toast} from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import {FC} from 'react';

interface MyComponentProps {
    message: string;
    isError: boolean;
}

const MyComponent: FC<MyComponentProps> = ({message, isError}) => {
    useEffect(() => {
        notify();
    }, []);

    const notify = () => {
        if (isError) {
            toast.error(message, {position: toast.POSITION.TOP_CENTER});
        } else {
            toast.success(message, {position: toast.POSITION.TOP_CENTER});
        }
    };

    return (
        <>
            <ToastContainer/>
        </>
    );
};

export default MyComponent;
